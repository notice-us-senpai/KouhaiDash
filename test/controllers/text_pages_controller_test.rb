require 'test_helper'

class TextPagesControllerTest < ActionController::TestCase
  setup do
    @text_page = text_pages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:text_pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create text_page" do
    assert_difference('TextPage.count') do
      post :create, text_page: { category_id: @text_page.category_id, contents: @text_page.contents, file_id: @text_page.file_id, load_from_google: @text_page.load_from_google, title: @text_page.title }
    end

    assert_redirected_to text_page_path(assigns(:text_page))
  end

  test "should show text_page" do
    get :show, id: @text_page
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @text_page
    assert_response :success
  end

  test "should update text_page" do
    patch :update, id: @text_page, text_page: { category_id: @text_page.category_id, contents: @text_page.contents, file_id: @text_page.file_id, load_from_google: @text_page.load_from_google, title: @text_page.title }
    assert_redirected_to text_page_path(assigns(:text_page))
  end

  test "should destroy text_page" do
    assert_difference('TextPage.count', -1) do
      delete :destroy, id: @text_page
    end

    assert_redirected_to text_pages_path
  end
end
