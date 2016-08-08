require 'test_helper'

class ResGroupsControllerTest < ActionController::TestCase
  setup do
    @res_group = res_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:res_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create res_group" do
    assert_difference('ResGroup.count') do
      post :create, res_group: { name: @res_group.name }
    end

    assert_redirected_to res_group_path(assigns(:res_group))
  end

  test "should show res_group" do
    get :show, id: @res_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @res_group
    assert_response :success
  end

  test "should update res_group" do
    patch :update, id: @res_group, res_group: { name: @res_group.name }
    assert_redirected_to res_group_path(assigns(:res_group))
  end

  test "should destroy res_group" do
    assert_difference('ResGroup.count', -1) do
      delete :destroy, id: @res_group
    end

    assert_redirected_to res_groups_path
  end
end
