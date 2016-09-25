require 'test_helper'

class ResYieldTest < ActiveSupport::TestCase

# --- Available yields ---

  test "all yields should be available for admin" do
    assert_equal ResYield.all.pluck(:id),
                 ResYield.available_yields_for(users(:admin)).pluck(:id)
  end

  test "yields of other user should be available for admin" do
    user_one   = users(:user_one)
    res_groups = user_one.res_groups
    recipes    = Recipe.where(res_group: res_groups)
    res_yields = ResYield.where(recipe: recipes)

    assert_equal res_yields.pluck(:id),
                 ResYield.available_yields_for(users(:admin), other_user_id: user_one).pluck(:id)
  end

  test "yields of other group should be available for admin" do
    rg         = res_groups(:group_one_for_user_one)
    res_yields = ResYield.where(recipe: rg.recipes)

    assert_equal res_yields.pluck(:id),
                 ResYield.available_yields_for(users(:admin), res_group_id: rg).pluck(:id)
  end

  test "yields of other recipe should be available for admin" do
    recipe     = recipes(:r_two_for_user_one)
    res_yields = recipe.res_yields

    assert_equal res_yields.pluck(:id),
                 ResYield.available_yields_for(users(:admin), recipe_id: recipe).pluck(:id)
  end

  test "should return empty set if user and group are not connected" do
    assert_empty ResYield.available_yields_for(users(:admin),
                                               other_user_id: users(:user_one).id,
                                               res_group_id: res_groups(:default_group_for_user_two).id)
  end

  test "should return own yields" do
    user_one   = users(:user_one)
    rg         = ResGroup.where(user: user_one)
    recipes    = Recipe.where(res_group: rg)
    res_yields = ResYield.where(recipe: recipes)

    assert_equal res_yields.pluck(:id),
                 ResYield.available_yields_for(user_one).pluck(:id)
  end

  test "yields of other user should not be available for regular user" do
    assert_empty ResYield.available_yields_for(users(:user_two), other_user_id: users(:user_one))
  end

  test "should return own yields with group filter" do
    user_one   = users(:user_one)
    rg         = res_groups(:group_one_for_user_one)
    res_yields = ResYield.where(recipe: rg.recipes)

    assert_equal res_yields.pluck(:id),
                 ResYield.available_yields_for(user_one, res_group_id: rg).pluck(:id)
  end

  test "should return own yields with recipe filter" do
    recipe     = recipes(:r_three_for_user_one)

    assert_equal recipe.res_yields.pluck(:id),
                 ResYield.available_yields_for(users(:user_one), recipe_id: recipe).pluck(:id)
  end

  test "should not return yields of other's group" do
    assert_empty ResYield.available_yields_for(users(:user_one),
                                               res_group_id: res_groups(:default_group_for_user_two))
  end

  test "should not return yields of other's recipe" do
    assert_empty ResYield.available_yields_for(users(:user_one),
                                               recipe_id: recipes(:r_two_for_user_two))
  end

end
