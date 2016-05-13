require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get profile" do
    get :profile
    assert_response :success
  end

  test "should get calendar" do
    get :calendar
    assert_response :success
  end

  test "should get tasks" do
    get :tasks
    assert_response :success
  end

  test "should get files" do
    get :files
    assert_response :success
  end

  test "should get contacts" do
    get :contacts
    assert_response :success
  end

end
