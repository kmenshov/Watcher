require 'test_helper'

class ResGroupTest < ActiveSupport::TestCase

  test "should know if self is default group" do
    assert res_groups(:default_group_for_user_one).default_group?
    refute res_groups(:group_one_for_user_one).default_group?
    refute res_groups(:group_two_for_user_one).default_group?
    assert res_groups(:default_group_for_user_two).default_group?
    refute res_groups(:group_one_for_user_two).default_group?
  end

# --- Available groups ---

  test "all groups should be available for admin" do
    assert_equal ResGroup.all.pluck(:id),
                 ResGroup.available_groups_for(users(:admin)).pluck(:id)
  end

  test "groups of other user should be available for admin" do
    user_one = users(:user_one)

    assert_equal ResGroup.where(user: user_one).pluck(:id),
                 ResGroup.available_groups_for(users(:admin), other_user_id: user_one).pluck(:id)
  end

  test "should return own groups" do
    user_one = users(:user_one)

    assert_equal ResGroup.where(user: user_one).pluck(:id),
                 ResGroup.available_groups_for(user_one).pluck(:id)
  end

  test "groups of other user should not be available for regular user" do
    assert_empty ResGroup.available_groups_for(users(:user_two), other_user_id: users(:user_one))
  end

# --- Ensure default group ---

  test "should move recipes to default group" do
    group         = res_groups(:group_one_for_user_one)
    default_group = res_groups(:default_group_for_user_one)

    assert_difference 'default_group.recipes.count', group.recipes.count do
      assert_no_difference 'ResYield.count' do
        assert_no_difference 'Recipe.count' do
          group.destroy
        end
      end
    end
  end

  test "should destroy recipes from default group" do
    default_group = res_groups(:default_group_for_user_one)
    yields_count = ResYield.where(recipe: default_group.recipes).count

    assert_difference 'ResYield.count', -yields_count do
      assert_difference 'Recipe.count', -default_group.recipes.count do
        default_group.destroy
      end
    end
  end

  test "should destroy recipes if no default group is present" do
    res_groups(:default_group_for_user_one).destroy
    group = res_groups(:group_one_for_user_one)
    yields_count = ResYield.where(recipe: group.recipes).count

    assert_difference 'ResYield.count', -yields_count do
      assert_difference 'Recipe.count', -group.recipes.count do
        group.destroy
      end
    end
  end

# --- Validations ---

  test "should validate user_id" do
    group = res_groups(:group_one_for_user_one).dup
    assert group.valid?

    group.user_id = 'incorrect'
    refute group.valid?

    begin
      user_id = rand(10000) + 1
    end while User.exists?(user_id)
    group.user_id = user_id
    refute group.valid?

    group.user_id = users(:user_two).id
    assert group.valid?
  end

end
