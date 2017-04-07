require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @tag = tags(:tagOne)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag" do
    assert_difference('Tag.count') do
      post :create, params: { tag: { text: @tag.text } }
    end

    assert_redirected_to tag_path(assigns(:tag))
  end

  test "should show tag" do
    get :show, params: { id: @tag }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @tag }
    assert_response :success
  end

  test "should update tag" do
    patch :update, params: { id: @tag, tag: { text: @tag.text } }
    assert_redirected_to tag_path(assigns(:tag))
  end

  test "should destroy tag" do
    assert_difference('Tag.count', -1) do
      delete :destroy, params: { id: @tag }
    end

    assert_redirected_to tags_path
  end
end