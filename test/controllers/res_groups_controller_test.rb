require 'test_helper'

class ResGroupsControllerTest < ActionController::TestCase
  setup do
    @user_one = users(:user_one)
    @admin    = users(:admin)
    @res_group = res_groups(:group_one_for_user_one)
  end

# --- Index ---

  test "should get index for own groups" do
    login_as @user_one
    get :index
    assert_response :success
    assert_not_nil assigns(:res_groups)
    assert_template 'res_groups/index'

    groups = ResGroup.where(user: @user_one)
    count = groups.count + 2 # with 'Groups' and 'New Group' links

    assert_select "a[href^=?]", res_groups_path, count: count do
      groups.each do |group|
        assert_select "a[href$=?]", group.id.to_s, text: group.name
      end
    end
  end

  test "should get all groups for admin" do
    login_as @admin
    get :index
    assert_response :success
    assert_not_nil assigns(:res_groups)
    assert_template 'res_groups/index'

    groups = ResGroup.all
    count = groups.count + 2 # with 'Groups' and 'New Group' links

    assert_select "a[href^=?]", res_groups_path, count: count do
      groups.each do |group|
        assert_select "a[href$=?]", group.id.to_s, text: group.name
      end
    end
  end

  test "should not get groups for not logged in" do
    get :index
    assert_login_required
  end

# --- New ---

  test "should get new" do
    login_as @user_one
    get :new
    assert_response :success
    assert_template 'res_groups/new'
  end

  test "should not get new for not logged in" do
    get :new
    assert_login_required
  end

# --- Create ---

  test "should create group" do
    login_as @user_one
    new_group_name = 'New Group'
    assert_difference('ResGroup.count') do
      post :create, res_group: { name: new_group_name }
    end
    assert_redirected_to res_group_path(assigns(:res_group))
    assert ResGroup.exists?(name: new_group_name, user: @user_one)
  end

  test "should not create group with reserved name" do
    login_as @user_one
    new_group_name = Rails.configuration.res_group_reserved_names[0]
    assert_no_difference('ResGroup.count') do
      post :create, res_group: { name: new_group_name }
    end
    assert_template 'res_groups/new'
    assert_not_nil flash
  end

  test "should not create group for not logged in" do
    new_group_name = 'whatever'
    assert_no_difference('ResGroup.count') do
      post :create, res_group: { name: new_group_name }
    end
    assert_login_required
  end


  def should_ensure_correct_user_while_creating(incorrect_user_id)
    login_as @user_one
    new_group_name = 'New Group'

    assert_difference('ResGroup.count') do
      post :create, res_group: { name: new_group_name,
                                 user_id: incorrect_user_id }
    end
    assert_redirected_to res_group_path(assigns(:res_group))

    assert ResGroup.exists?(name: new_group_name,
                            user_id: @user_one.id)

    assert_equal ResGroup.find(assigns(:res_group).id).user_id, @user_one.id
  end


  test "should create when user id is incorrect" do
    should_ensure_correct_user_while_creating 'some_string'
  end

  test "should create when user id is inexistent" do
    begin
      u = rand(100) + 1
    end while User.exists?(u)
    should_ensure_correct_user_while_creating u
  end

  test "should create when user id is from different user" do
    should_ensure_correct_user_while_creating users(:user_two).id
    should_ensure_correct_user_while_creating users(:user_two).id
  end


# --- Show ---

  test "should show own group" do
    login_as @user_one
    get :show, id: @res_group
    assert_response :success
    assert_template 'res_groups/show'
  end

  test "should show group for admins" do
    login_as @admin
    get :show, id: @res_group
    assert_response :success
    assert_template 'res_groups/show'
  end

  test "should not show group for others" do
    login_as users(:user_two)
    get :show, id: @res_group
    assert_redirected_with_flash_to res_groups_url
  end

  test "should not show group for not logged in" do
    get :show, id: @res_group
    assert_login_required
  end

# --- Edit ---

  test "should get edit for own group" do
    login_as @user_one
    get :edit, id: @res_group
    assert_response :success
    assert_template 'res_groups/edit'
  end

  test "should get edit group for admin" do
    login_as @admin
    get :edit, id: @res_group
    assert_response :success
    assert_template 'res_groups/edit'
  end

  test "should not get edit group for others" do
    login_as users(:user_two)
    get :edit, id: @res_group
    assert_redirected_with_flash_to res_groups_url
  end

  test "should not get edit group for not logged in" do
    get :edit, id: @res_group
    assert_login_required
  end

  test "should not get edit for default group" do
    login_as @user_one
    get :edit, id: res_groups(:default_group_for_user_one).id
    assert_redirected_with_flash_to res_groups_url
  end

# --- Update ---

  test "should update own group" do
    login_as @user_one
    gname = 'Updated Group'
    patch :update, id: @res_group, res_group: { name: gname }
    assert_redirected_to res_group_path(assigns(:res_group))
    assert_equal @res_group.reload.name, gname
  end

  test "should update group by admin" do
    login_as @admin
    gname = 'Updated Group'
    patch :update, id: @res_group, res_group: { name: gname,
                                                user_id: @res_group.user_id }
    assert_redirected_to res_group_path(@res_group)
    @res_group.reload
    assert_equal @res_group.name, gname
    assert_equal @res_group.user_id, @user_one.id
  end

  test "should not update group by others" do
    login_as users(:user_two)
    gname = 'Updated Group'
    patch :update, id: @res_group, res_group: { name: gname }
    assert_redirected_with_flash_to res_groups_url
    assert_not_equal @res_group.reload.name, gname
  end

  test "should not update group by not logged in" do
    gname = 'Updated Group'
    patch :update, id: @res_group, res_group: { name: gname }
    assert_login_required
    assert_not_equal @res_group.reload.name, gname
  end

  test "should not update default group" do
    login_as @user_one
    gname = 'Updated Group'
    group = res_groups(:default_group_for_user_one)
    patch :update, id: group, res_group: { name: gname }
    assert_redirected_with_flash_to res_groups_url
    assert_not_equal group.reload.name, gname
  end

  test "should not update group to default name" do
    login_as @user_one
    gname = Rails.configuration.res_group_reserved_names[0]
    patch :update, id: @res_group, res_group: { name: gname }
    assert_template 'res_groups/edit'
    assert_not_nil flash
    assert_not_equal @res_group.reload.name, gname
  end

# --- Destroy ---

  test "should destroy own group" do
    login_as @user_one
    assert_difference('ResGroup.count', -1) do
      delete :destroy, id: @res_group
    end
    assert_redirected_to res_groups_url
  end

  test "should destroy group by admin" do
    login_as @admin
    assert_difference('ResGroup.count', -1) do
      delete :destroy, id: @res_group
    end
    assert_redirected_to res_groups_url
  end

  test "should not destroy group by others" do
    login_as users(:user_two)
    assert_no_difference('ResGroup.count') do
      delete :destroy, id: @res_group
    end
    assert_redirected_with_flash_to res_groups_url
  end

  test "should not destroy group by not logged in" do
    assert_no_difference('ResGroup.count') do
      delete :destroy, id: @res_group
    end
    assert_login_required
  end

  test "should not destroy default group" do
    login_as @user_one
    group = res_groups(:default_group_for_user_one)
    assert_no_difference('ResGroup.count') do
      delete :destroy, id: group
    end
    assert_redirected_with_flash_to res_groups_url
  end

end
