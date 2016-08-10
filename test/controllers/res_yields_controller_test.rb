require 'test_helper'

class ResYieldsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get rewatch" do
    get :rewatch
    assert_response :success
  end

end
