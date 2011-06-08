require 'spec_helper'

describe Organization do

  before do
    @organization = Organization.create(:name => "Google", :balance => 100)
  end

  describe "#tasks" do
    before do
      Task.should_receive(:in_organization).once.with(@organization)
    end

    it "should call Task.in_organization with itself" do
      @organization.tasks
    end
  end

  describe "#add_to_balance" do
    it "should have balance == 200" do
      @organization.add_to_balance(100)
      @organization.balance.should == 200
    end 
  end

  describe "calculation methods" do
    before do
      # Defining mock invoices
      @invoice1 = mock_model(Invoice, :total => 893.909, :base => 757.55, :iva => 0.18, :iva_part => 136.359)
      @invoice2 = mock_model(Invoice, :total => 413.0, :base => 350, :iva => 0.18, :iva_part => 63)
      @invoice3 = mock_model(Invoice, :total => 118.0, :base => 100, :iva => 0.18, :iva_part => 18)
      @invoices = [@invoice1, @invoice2]
      
      # Defining mock payments
      @payment1 = mock_model(Payment, :total => 300, :iva_part => 0.0)
      @payment2 = mock_model(Payment, :total => 155.23, :iva => 0.18, :iva_part => 27.9414)
      @payments = [@payment1, @payment2]
      
      # Defining mock projects
      @project1 = mock_model(Project, :name => "Fer truita de patates", :type => "tipus", :comission_to_cash => 166.1325)
      @project1.stub_chain(:invoices, :paid_within => [@invoice1, @invoice2])
      @project1.stub_chain(:type, :comission).and_return(0.15) # comission = 757.55 + 350 * 0.15 = 166.1325
      @project2 = mock_model(Project, :name => "Fer entrepà de pernil", :type => "tipus", :comission_to_cash => 10)
      @project2.stub_chain(:invoices, :paid_within => [@invoice3])
      @project2.stub_chain(:type, :comission).and_return(0.10) # comission = 100 * 0.10 = 10
      @projects = [@project1, @project2]
    end

    describe "#calculate_gross_worth_balance" do
      before do
        @aux = mock("paid invoices")
        @aux.should_receive(:paid_within).and_return(@invoices)
        @organization.should_receive(:invoices).and_return(@aux)
      end

      it "should return 1306.909" do
        @organization.calculate_gross_worth_balance.should be_close(1306.909, 0.1)
      end
    end

    describe "#calculate_worth_balance" do
      before do
        @aux = mock("paid invoices")
        @aux.should_receive(:paid_within).and_return(@invoices)
        @organization.should_receive(:invoices).and_return(@aux)
      end

      it "should return 1107.55" do
        @organization.calculate_worth_balance.should be_close(1107.55, 0.1)
      end
    end

    describe "#calculate_payments_balance" do
      before do
        @aux = mock("accountable and paid payments")
        @aux.stub_chain(:accountable, :paid_within).and_return(@payments)
        @organization.should_receive(:payments).and_return(@aux)
      end

      it "should return 455.23" do
        @organization.calculate_payments_balance.should be_close(455.23, 0.1)
      end
    end

    describe "#calculate_balance" do
      before do
        @organization.should_receive(:calculate_worth_balance).once.and_return(1107.55)
        @organization.should_receive(:calculate_payments_balance).once.and_return(455.23)
      end

      it "should be 652.32" do
        @organization.calculate_balance.should be_close(652.32, 0.1)
      end
    end

    describe "#calculate_received_iva" do
      before do
        @aux = mock("paid invoices")
        @aux.should_receive(:paid_within).and_return(@invoices)
        @organization.should_receive(:invoices).and_return(@aux)
      end

      it "should be 199.359" do
        @organization.calculate_received_iva.should be_close(199.359, 0.1)
      end
    end

    describe "#calculate_paid_iva" do
      before do
        @aux = mock("paid payments")
        @aux.should_receive(:paid_within).and_return(@payments)
        @organization.should_receive(:payments).and_return(@aux)
      end

      it "should be 27.94" do
        @organization.calculate_paid_iva.should be_close(27.94, 0.1)
      end
    end

    describe "#calculate_balanced_iva" do
      before do
        @organization.should_receive(:calculate_received_iva).once.and_return(199.359)
        @organization.should_receive(:calculate_paid_iva).once.and_return(27.94)
      end

      it "should be 171.42" do
        @organization.calculate_balanced_iva.should be_close(171.42, 0.1)
      end
    end

    describe "#calculate_comissions_to_cash" do
      before do
        @aux = mock("projects started between two any dates")
        @aux.should_receive(:started_between).and_return(@projects)
        @organization.should_receive(:projects).and_return(@aux)
      end

      it "should be 166.13" do
        @organization.calculate_comissions_to_cash.should be_close(176.13, 0.1)
      end
    end

    describe "#calculate_payments_of_employee" do
      before do
        @aux = mock("a bunch of payments")
        @aux.stub_chain(:accountable, :paid_within).and_return(@payments)
        @employee = mock("an employee")
        @employee.stub!(:payments).and_return(@aux)
        @organization.should_receive(:employee).and_return(@employee)
      end

      it "should return 455.23" do
        @organization.calculate_payments_of_employee(nil).should be_close(455.23, 0.1) 
      end
    end

    describe "#calculate_comissions_of_employee" do
      before do
        @employee = mock("an employee")
        @employee.stub_chain(:projects_as_comercial, :started_between).and_return([@project1]) 
      end

      it "should return 166.13" do
        @organization.calculate_comissions_of_employee(@employee).should be_close(166.13, 0.1)
      end
    end

    describe "#calculate_wage_of_employee" do
      before do
        @contract = mock("a contract", :hours => 8, :salary => 17.5)
        @employee = mock("an employee")
        @employee.should_receive(:contract_for).once.with(@organization).and_return(@contract)
        @employee.stub_chain(:tasks, :completed_between, :sum).and_return(100)
      end

      it "should return a salary of 1750" do
        @organization.calculate_wage_of_employee(@employee).should be_close(1750, 0.1)
      end
    end

    describe "#calculate_wages" do
      before do
        @employee1 = mock("an employee")
        @employee2 = mock("another employee")
        @organization.should_receive(:employees).and_return([@employee1, @employee2])
        @organization.should_receive(:calculate_wage_of_employee).twice.and_return(40, 50)
      end

      it "should return 90" do
        @organization.calculate_wages.should == 90
      end
    end
  end

  describe "#checkout" do
    before do
      @organization.stub!(:calculate_worth_balance).and_return(1107.55)
      @organization.stub!(:calculate_balance).and_return(652.32)
      @organization.stub!(:calculate_balanced_iva).and_return(171.42)
      @organization.stub!(:calculate_payments_balance).and_return(455.23)
      @organization.stub!(:calculate_wages).and_return(2000)
      @organization.should_receive(:calculate_wage_of_employee).twice.and_return(1000, 1000)

      @employee1 = mock_model(Employee, :email => "uno@fake.com")
      @employee2 = mock_model(Employee, :email => "dos@fake.com")
      @organization.stub!(:employees).and_return([@employee1, @employee2])

      @payment1 = mock("a payment", :total => 120)
      @payment1.stub_chain(:payer, :email).and_return("uno@fake.com")
      @payment2 = mock("a second payment", :total => 60)
      @payment2.stub_chain(:payer, :email).and_return("uno@fake.com")
      @payment3 = mock("a third payment", :total => 180)
      @payment3.stub_chain(:payer, :email).and_return("dos@fake.com")
      @organization.stub_chain(:payments, :uncashed).and_return([@payment1, @payment2, @payment3])

      @p1_type = mock("a project type", :comission => 0.3)
      @project1 = mock("a project")
      @project1.stub!(:type).and_return(@p1_type)
      @project1.stub!(:comission_to_cash).and_return(60)
      @invoice1 = mock("an invoice", :base => 40)
      @invoice2 = mock("another invoice", :base => 50)
      @project1.stub_chain(:invoices, :paid_within).and_return([@invoice1, @invoice2])
      @project1.should_receive(:update_attribute).once.with(:comission_to_cash, an_instance_of(Float))
      @comercial1 = mock("a comercial", :email => "uno@fake.com")
      @project1.stub!(:comercial).and_return(@comercial1)
 
      @p2_type = mock("a project type", :comission => 0.15)
      @project2 = mock("a project")
      @project2.stub!(:type).and_return(@p2_type)
      @project2.stub!(:comission_to_cash).and_return(130)
      @invoice3 = mock("an invoice", :base => 80)
      @invoice4 = mock("another invoice", :base => 150)
      @project2.stub_chain(:invoices, :paid_within).and_return([@invoice3, @invoice4])
      @project2.should_receive(:update_attribute).once.with(:comission_to_cash, an_instance_of(Float))
      @comercial2 = mock("a comercial", :email => "dos@fake.com")
      @project2.stub!(:comercial).and_return(@comercial2)
 
      @organization.stub_chain(:projects, :started_between).and_return([@project1, @project2])
    end

    it "should return the rest of worth balance" do
      @organization.checkout.should be_close(686.05, 0.1)
    end
  end
end
