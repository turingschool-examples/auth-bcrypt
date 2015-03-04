require_relative '../test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader:user

  def setup
    @user = User.create(username: 'Richard', password: 'LaBamba')
  end

  test "registered user can view their profile" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    within("#banner") do
      assert page.has_content?("Richard's profile")
    end
  end

  test "unregistered user cannot view a user's profile" do
    ApplicationController.any_instance.stubs(:current_user).returns(nil)
    visit user_path(user)
    within("#flash_alert") do
      assert page.has_content?("Not authorized")
    end
  end

  test "registered user cannot view other users' profile" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    protected_user = User.create(username: "protected",  password: "password", password_confirmation: "password")
    visit user_path(protected_user)
    within("#flash_alert") do
      assert page.has_content?("You are not authorized to access this page")
    end
  end

  test "an admin user can view any user's profile" do
    skip
    admin_user = User.create(username: "protected",  password: "password", password_confirmation: "password", role: "admin")
    ApplicationController.any_instance.stubs(:current_user).returns(admin_user)
    visit user_path(user)
    within("#banner") do
      assert page.has_content?("Welcome example")
    end
  end
end

