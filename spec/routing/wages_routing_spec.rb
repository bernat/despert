require "spec_helper"

describe WagesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/wages" }.should route_to(:controller => "wages", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/wages/new" }.should route_to(:controller => "wages", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/wages/1" }.should route_to(:controller => "wages", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/wages/1/edit" }.should route_to(:controller => "wages", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/wages" }.should route_to(:controller => "wages", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/wages/1" }.should route_to(:controller => "wages", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/wages/1" }.should route_to(:controller => "wages", :action => "destroy", :id => "1")
    end

  end
end
