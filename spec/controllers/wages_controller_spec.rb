require 'spec_helper'

describe WagesController do

  def mock_wage(stubs={})
    (@mock_wage ||= mock_model(Wage).as_null_object).tap do |wage|
      wage.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all wages as @wages" do
      Wage.stub(:all) { [mock_wage] }
      get :index
      assigns(:wages).should eq([mock_wage])
    end
  end

  describe "GET show" do
    it "assigns the requested wage as @wage" do
      Wage.stub(:find).with("37") { mock_wage }
      get :show, :id => "37"
      assigns(:wage).should be(mock_wage)
    end
  end

  describe "GET new" do
    it "assigns a new wage as @wage" do
      Wage.stub(:new) { mock_wage }
      get :new
      assigns(:wage).should be(mock_wage)
    end
  end

  describe "GET edit" do
    it "assigns the requested wage as @wage" do
      Wage.stub(:find).with("37") { mock_wage }
      get :edit, :id => "37"
      assigns(:wage).should be(mock_wage)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created wage as @wage" do
        Wage.stub(:new).with({'these' => 'params'}) { mock_wage(:save => true) }
        post :create, :wage => {'these' => 'params'}
        assigns(:wage).should be(mock_wage)
      end

      it "redirects to the created wage" do
        Wage.stub(:new) { mock_wage(:save => true) }
        post :create, :wage => {}
        response.should redirect_to(wage_url(mock_wage))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved wage as @wage" do
        Wage.stub(:new).with({'these' => 'params'}) { mock_wage(:save => false) }
        post :create, :wage => {'these' => 'params'}
        assigns(:wage).should be(mock_wage)
      end

      it "re-renders the 'new' template" do
        Wage.stub(:new) { mock_wage(:save => false) }
        post :create, :wage => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested wage" do
        Wage.should_receive(:find).with("37") { mock_wage }
        mock_wage.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :wage => {'these' => 'params'}
      end

      it "assigns the requested wage as @wage" do
        Wage.stub(:find) { mock_wage(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:wage).should be(mock_wage)
      end

      it "redirects to the wage" do
        Wage.stub(:find) { mock_wage(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(wage_url(mock_wage))
      end
    end

    describe "with invalid params" do
      it "assigns the wage as @wage" do
        Wage.stub(:find) { mock_wage(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:wage).should be(mock_wage)
      end

      it "re-renders the 'edit' template" do
        Wage.stub(:find) { mock_wage(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested wage" do
      Wage.should_receive(:find).with("37") { mock_wage }
      mock_wage.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the wages list" do
      Wage.stub(:find) { mock_wage }
      delete :destroy, :id => "1"
      response.should redirect_to(wages_url)
    end
  end

end
