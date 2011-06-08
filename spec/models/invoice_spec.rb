require 'spec_helper'

describe Invoice do
  describe ".next_number" do
    context "when there are no invoices in the current year" do
      it "should return the correct number" do
        Invoice.next_number.should == "#{Date.today.year}0001"
      end
    end

    context "when previous invoices exists in this year" do
      it "should follow the numeration for the current year" do
        Factory.create :invoice
        Invoice.next_number.should == "#{Date.today.year}0002"
      end
    end
  end
end
