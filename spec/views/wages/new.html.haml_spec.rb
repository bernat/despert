require 'spec_helper'

describe "wages/new.html.haml" do
  before(:each) do
    assign(:wage, stub_model(Wage,
      :concept => "MyString",
      :base => 1.5,
      :iva => 1.5,
      :ret => 1.5,
      :user_id => 1,
      :billing_name => "MyString",
      :billing_cif => "MyString",
      :billing_address => "MyString",
      :billing_town => "MyString",
      :billing_zip => "MyString",
      :billing_province => "MyString",
      :billing_country => "MyString",
      :number => "MyString"
    ).as_new_record)
  end

  it "renders new wage form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => wages_path, :method => "post" do
      assert_select "input#wage_concept", :name => "wage[concept]"
      assert_select "input#wage_base", :name => "wage[base]"
      assert_select "input#wage_iva", :name => "wage[iva]"
      assert_select "input#wage_ret", :name => "wage[ret]"
      assert_select "input#wage_user_id", :name => "wage[user_id]"
      assert_select "input#wage_billing_name", :name => "wage[billing_name]"
      assert_select "input#wage_billing_cif", :name => "wage[billing_cif]"
      assert_select "input#wage_billing_address", :name => "wage[billing_address]"
      assert_select "input#wage_billing_town", :name => "wage[billing_town]"
      assert_select "input#wage_billing_zip", :name => "wage[billing_zip]"
      assert_select "input#wage_billing_province", :name => "wage[billing_province]"
      assert_select "input#wage_billing_country", :name => "wage[billing_country]"
      assert_select "input#wage_number", :name => "wage[number]"
    end
  end
end
