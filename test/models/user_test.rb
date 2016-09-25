require 'test_helper'

class UserTest < ActiveSupport::TestCase

# --- default_group ---

  test "should know default group for user" do
    assert_equal users(:user_one).default_group, res_groups(:default_group_for_user_one)
    assert_equal users(:user_two).default_group, res_groups(:default_group_for_user_two)
  end

# --- Available users ---

  test "all users should be available for admin" do
    assert_equal User.all.pluck(:id),
                 User.available_users_for(users(:admin)).pluck(:id)
  end

  test "self should be available for regular user" do
    assert_equal User.available_users_for(users(:user_one)).pluck(:id),
                 Array.new.push(users(:user_one).id)
  end

  test "others should not be available for regular user" do
    # kinda redundant having the previous test, I know
    refute_includes User.available_users_for(users(:user_one)).pluck(:id), users(:user_two).id
  end


end
