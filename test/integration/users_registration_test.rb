require 'test_helper'

class UsersRegistrationTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get register_path
    assert_no_difference 'User.count' do
      post users_path, user: { 
      	username:  "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar" 
      }
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get register_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { 
      	username:  "Example User",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password" }
    end
    assert_template 'users/show'
    assert is_logged_in?
  end
end
