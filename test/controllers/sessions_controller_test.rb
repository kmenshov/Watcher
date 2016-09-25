require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

# --- New ---

  test "should get new" do
    get :new
    assert_response :success
    assert_template 'sessions/new'
  end

# --- Create ---

  test "should not login with incorrect email" do
    post :create, session: { email: 'wrong@example.com', password: 'password' }
    assert_template 'sessions/new'
    assert_not_nil flash
  end

  test "should not login with incorrect password" do
    post :create, session: { email: users(:user_one).email, password: 'wrong_password' }
    assert_template 'sessions/new'
    assert_not_nil flash
  end

  test "should login with correct credentials" do
    assert_nil session[:user_id]
    post :create, session: { email: users(:user_one).email, password: 'password' }
    assert_redirected_to root_url
    assert_not_nil session[:user_id]
  end

# --- Destroy ---

  test "should log out" do
    login_as users(:user_one)
    delete :destroy
    assert_nil session[:user_id]
    assert_redirected_to root_url
  end

  test "should log out if not logged in" do
    delete :destroy
    assert_redirected_to root_url
  end

end
