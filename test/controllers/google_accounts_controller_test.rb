require 'test_helper'

class GoogleAccountsControllerTest < ActionController::TestCase
  setup do
    @google_account = google_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:google_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create google_account" do
    assert_difference('GoogleAccount.count') do
      post :create, google_account: { access_token: @google_account.access_token, expires_at: @google_account.expires_at, gmail: @google_account.gmail, refresh_token: @google_account.refresh_token, user_id: @google_account.user_id }
    end

    assert_redirected_to google_account_path(assigns(:google_account))
  end

  test "should show google_account" do
    get :show, id: @google_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @google_account
    assert_response :success
  end

  test "should update google_account" do
    patch :update, id: @google_account, google_account: { access_token: @google_account.access_token, expires_at: @google_account.expires_at, gmail: @google_account.gmail, refresh_token: @google_account.refresh_token, user_id: @google_account.user_id }
    assert_redirected_to google_account_path(assigns(:google_account))
  end

  test "should destroy google_account" do
    assert_difference('GoogleAccount.count', -1) do
      delete :destroy, id: @google_account
    end

    assert_redirected_to google_accounts_path
  end
end
