# require 'spec_helper'
# 
# describe User do
# 
#   describe "a new user" do
#     before do
#       @user = Factory.build(:user)
#     end
# 
#     it "should validate a user with name, login, email and password" do
#       @user.should be_valid
#     end
# 
#     it "should require email" do
#       @user.email = nil
#       @user.should_not be_valid
#       @user.should have(2).errors_on(:email)
#     end
# 
#     it "should require login" do
#       @user.login = nil
#       @user.should_not be_valid
#       @user.should have(2).errors_on(:login)
#     end
# 
#     it "should require name" do
#       @user.name = nil
#       @user.should_not be_valid
#       @user.should have(1).error_on(:name)
#     end
# 
#     it "should fail without a password confirmation" do
#       @user.password_confirmation = nil
#       @user.should_not be_valid
#       @user.password_confirmation = "12345"
#       @user.should_not be_valid
#       @user.password_confirmation = "passw0rd"
#       @user.should be_valid
#     end
# 
#     it "should be able to have projects"
#     # ...
#   end
# 
#   
#   describe "admin user" do
#     before do
#       @user = Factory(:user, :admin => true)
#     end
# 
#     it "should be able to create a project"
#     it "should be able to delete a project"
#     it "should be able to edit a project"
#     it "should be able to add people to a project"
#     # ...
#   end
# 
#   describe "regular user" do
#     before do
#       @user = Factory(:user, :admin => false)
#     end
# 
#     it "should not be able to create a project"
#     it "should not be able to destroy a project"
#     it "should not be able to edit a project"
#     # ...
#   end
# 
# end
