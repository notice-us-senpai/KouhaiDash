require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:jiayee)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { 
    	username: @user.username, 
    	email: @user.email 
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
