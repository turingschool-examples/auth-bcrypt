require_relative '../test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    Capybara.reset!
  end

  test "user cannot login without username and password" do
    visit login_path
    click_link_or_button "Login"
    within("#flash_errors") do
      assert page.has_content?("Invalid")
    end
  end

  test "registered user can login" do
    user = User.create(username: "example",  password: "password", password_confirmation: "password")
    visit login_path
    fill_in "session[username]", with: "example"
    fill_in "session[password]", with: "password"
    click_link_or_button "Login"
    within("#banner") do
      page.has_content?("example's profile")
    end
  end
end
