require 'spec_helper'

describe "wages/index.html.haml" do
  before(:each) do
    assign(:wages, [
      stub_model(Wage,
        :concept => "Concept",
        :base => 1.5,
        :iva => 1.5,
        :ret => 1.5,
        :user_id => 1,
        :billing_name => "Billing Name",
        :billing_cif => "Billing Cif",
        :billing_address => "Billing Address",
        :billing_town => "Billing Town",
        :billing_zip => "Billing Zip",
        :billing_province => "Billing Province",
        :billing_country => "Billing Country",
        :number => "Number"
      ),
      stub_model(Wage,
        :concept => "Concept",
        :base => 1.5,
        :iva => 1.5,
        :ret => 1.5,
        :user_id => 1,
        :billing_name => "Billing Name",
        :billing_cif => "Billing Cif",
        :billing_address => "Billing Address",
        :billing_town => "Billing Town",
        :billing_zip => "Billing Zip",
        :billing_province => "Billing Province",
        :billing_country => "Billing Country",
        :number => "Number"
      )
    ])
  end

  it "renders a list of wages" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Concept".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Billing Name".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Billing Cif".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Billing Address".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Billing Town".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Billing Zip".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Billing Province".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Billing Country".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Number".to_s, :count => 2
  end
end
