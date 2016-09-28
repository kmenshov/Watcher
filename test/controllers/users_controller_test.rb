require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user_one = users(:user_one)
    @user_two = users(:user_two)
    @admin    = users(:admin)
  end

# --- Index ---

  test "should get index for admin" do
    login_as @admin
    get :index
    assert_response :success
    assert_template 'users/index'
    assert_not_nil assigns(:users)
  end

  test "should not get index for regular user" do
    login_as @user_one
    get :index
    assert_redirected_with_flash_to root_url
  end

  test "should not get index for not logged in" do
    get :index
    assert_login_required
  end

# --- New ---

  test "should get new for admin" do
    login_as @admin
    get :new
    assert_response :success
    assert_template 'users/new'
  end

  test "should not get new for regular user" do
    login_as @user_one
    get :new
    assert_redirected_with_flash_to root_url
  end

  test "should not get new for not logged in" do
    get :new
    assert_login_required
  end

# --- Create ---

  test "should create user by admin" do
    login_as @admin
    assert_difference('User.count') do
      post :create, user: { email: 'new@example.com',
                            password: 'password',
                            password_confirmation: 'password' }
    end
    assert_redirected_to user_path(assigns(:user))
    assert ResGroup.exists?(name: Rails.configuration.res_group_reserved_names[0], user_id: assigns(:user)),
                    "Should have created default group for new user"
  end

  test "should not create user by regular user" do
    login_as @user_one
    assert_no_difference('User.count') do
      post :create, user: { email: 'new@example.com',
                            password: 'password',
                            password_confirmation: 'password' }
    end
    assert_redirected_with_flash_to root_url
  end

  test "should not create user by not logged in" do
    assert_no_difference('User.count') do
      post :create, user: { email: 'new@example.com',
                            password: 'password',
                            password_confirmation: 'password' }
    end
    assert_login_required
  end

# --- Show ---

  test "should show users to themselves" do
    login_as @user_one
    get :show, id: @user_one
    assert_response :success
    assert_template 'users/show'
  end

  test "should show users to admin" do
    login_as @admin
    get :show, id: @user_one
    assert_response :success
    assert_template 'users/show'
  end

  test "should not show users to others" do
    login_as @user_two
    get :show, id: @user_one
    assert_redirected_with_flash_to users_url
  end

  test "should not show users to not logged in" do
    get :show, id: @user_one
    assert_login_required
  end

# --- Edit ---

  test "should get edit users for themselves" do
    login_as @user_one
    get :edit, id: @user_one
    assert_response :success
    assert_template 'users/edit'
  end

  test "should get edit users for admin" do
    login_as @admin
    get :edit, id: @user_one
    assert_response :success
    assert_template 'users/edit'
  end

  test "should not get edit users for others" do
    login_as @user_two
    get :edit, id: @user_one
    assert_redirected_with_flash_to users_url
  end

  test "should not get edit users for not logged in" do
    get :edit, id: @user_one
    assert_login_required
  end

# --- Update ---

  test "should update user by admin" do
    login_as @admin
    email = 'updated@example.com'
    patch :update, id: @user_one, user: { email: email, password: '', password_confirmation: '' }
    assert_redirected_to user_path(@user_one)
    assert_equal @user_one.reload.email, email
  end

  test "should update user by themselves" do
    login_as @user_one
    email = 'updated@example.com'
    patch :update, id: @user_one, user: { email: email, password: '', password_confirmation: '' }
    assert_redirected_to user_path(@user_one)
    assert_equal @user_one.reload.email, email
  end

  test "should not update user by others" do
    login_as @user_two
    email = 'updated@example.com'
    patch :update, id: @user_one, user: { email: email, password: '', password_confirmation: '' }
    assert_redirected_with_flash_to users_url
    assert_not_equal @user_one.reload.email, email
  end

  test "should not update user by not logged in" do
    email = 'updated@example.com'
    patch :update, id: @user_one, user: { email: email, password: '', password_confirmation: '' }
    assert_login_required
    assert_not_equal @user_one.reload.email, email
  end

# --- Destroy ---

  test "should destroy user by admin" do
    login_as @admin
    assert_difference('User.count', -1) do
      delete :destroy, id: @user_one
    end
    assert_redirected_to users_url
  end

  test "should destroy user by themselves" do
    login_as @user_one
    assert_difference('User.count', -1) do
      delete :destroy, id: @user_one
    end
    assert_redirected_to users_url
  end

  test "should not destroy user by others" do
    login_as @user_two
    assert_no_difference('User.count') do
      delete :destroy, id: @user_one
    end
    assert_redirected_with_flash_to users_url
  end

  test "should not destroy user by not logged in" do
    assert_no_difference('User.count') do
      delete :destroy, id: @user_one
    end
    assert_login_required
  end

end
