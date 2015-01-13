require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: "example",  password: "password", password_confirmation: "password")
    visit login_path
  end

  test "user cannot login without username and password" do
    click_link_or_button "Login"
    within("#errors") do
      assert page.has_content?("Invalid")
    end
  end

  test "registered user can login" do
    fill_in "session[username]", with: "example"
    fill_in "session[password]", with: "password"
    click_link_or_button "Login"
    within("#flash_notice") do
      assert page.has_content?("Login successful")
    end
  end

  test "registered user can view their profile" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    within("#banner") do
      assert page.has_content?("Welcome example")
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
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    protected_user = User.create(username: "protected",  password: "password", password_confirmation: "password")
    visit user_path(protected_user)
    within("#flash_alert") do
      assert page.has_content?("You are not authorized to access this page")
    end
  end

  test "an admin user can view any user's profile" do
    admin_user = User.create(username: "protected",  password: "password", password_confirmation: "password", role: "admin")
    ApplicationController.any_instance.stubs(:current_user).returns(admin_user)
    visit user_path(user)
    within("#banner") do
      assert page.has_content?("Welcome example")
    end
  end
end
