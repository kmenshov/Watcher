require 'test_helper'

class RedirectsControllerTest < ActionController::TestCase
  test "should get filter_by_group" do
    get :filter_by_group
    assert_response :success
  end

  test "should get filter_by_recipe" do
    get :filter_by_recipe
    assert_response :success
  end

end
