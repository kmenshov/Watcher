require 'test_helper'

class RecipeTest < ActiveSupport::TestCase

# --- User ---

  test "should provide user" do
    assert_equal Recipe.last.res_group.user, Recipe.last.user
  end

  test "should provide nil for user if res_group_id is incorrect" do
    recipe = Recipe.last
    recipe.res_group_id = 'incorrect'
    assert_nil recipe.user
  end

  test "should provide nil for user if res_group_id is nonexistent" do
    recipe = Recipe.last
    begin
      rg = rand(100) + 1
    end while ResGroup.exists?(rg)
    recipe.res_group_id = rg
    assert_nil recipe.user
  end

# --- Validations ---

  test "should validate res_group_id" do
    recipe = recipes(:r_two_for_user_one).dup
    assert recipe.valid?

    recipe.res_group_id = 'incorrect'
    refute recipe.valid?

    begin
      rg = rand(100) + 1
    end while ResGroup.exists?(rg)
    recipe.res_group_id = rg
    refute recipe.valid?

    recipe.res_group_id = res_groups(:group_one_for_user_two).id
    assert recipe.valid?
  end

# --- Available recipes ---

  test "all recipes should be available for admin" do
    assert_equal Recipe.all.pluck(:id),
                 Recipe.available_recipes_for(users(:admin)).pluck(:id)
  end

  test "recipes of other user should be available for admin" do
    user_one = users(:user_one)
    rg       = ResGroup.where(user: user_one)
    recipes  = Recipe.where(res_group: rg)

    assert_equal recipes.pluck(:id),
                 Recipe.available_recipes_for(users(:admin), other_user_id: user_one).pluck(:id)
  end

  test "recipes of other group should be available for admin" do
    rg      = res_groups(:group_one_for_user_one)
    recipes = Recipe.where(res_group: rg)

    assert_equal recipes.pluck(:id),
                 Recipe.available_recipes_for(users(:admin), res_group_id: rg).pluck(:id)
  end

  test "should return empty set if user and group are not connected" do
    assert_empty Recipe.available_recipes_for(users(:admin),
                                              other_user_id: users(:user_one).id,
                                              res_group_id: res_groups(:default_group_for_user_two).id)
  end

  test "should return own recipes" do
    user_one = users(:user_one)
    rg       = ResGroup.where(user: user_one)
    recipes  = Recipe.where(res_group: rg)

    assert_equal recipes.pluck(:id),
                 Recipe.available_recipes_for(user_one).pluck(:id)
  end

  test "recipes of other user should not be available for regular user" do
    assert_empty Recipe.available_recipes_for(users(:user_two), other_user_id: users(:user_one))
  end

  test "should return own recipes with group filter" do
    user_one = users(:user_one)
    rg       = res_groups(:group_one_for_user_one)
    recipes  = Recipe.where(res_group: rg)

    assert_equal recipes.pluck(:id),
                 Recipe.available_recipes_for(user_one, res_group_id: rg).pluck(:id)
  end

  test "should not return recipes of other's group" do
    assert_empty Recipe.available_recipes_for(users(:user_one),
                                              res_group_id: res_groups(:default_group_for_user_two))
  end

# --- Destroy ---

  test "should destroy dependent yields" do
    recipe           = recipes(:r_two_for_user_one)
    r_id             = recipe.id
    yields_to_delete = recipe.res_yields.count

    refute_empty ResYield.where(recipe_id: r_id)

    assert_difference('ResYield.count', -yields_to_delete) do
      recipe.destroy
    end

    assert_empty ResYield.where(recipe_id: r_id)
  end

end
