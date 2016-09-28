require 'test_helper'

class FilteringFormsTest < ActionDispatch::IntegrationTest

  setup do
    login_as users(:user_one)
    @res_group = res_groups(:group_one_for_user_one)
  end

  test "should filter recipes by group" do
    post filter_recipes_path, res_group_id: @res_group.id
    assert_redirected_to res_group_recipes_url(@res_group)
    follow_redirect!
    assert_template 'recipes/index'

    count = @res_group.recipes.count + 2 # with 'Recipes' and 'New Recipe' links

    assert_select "a[href^=?]", recipes_path, count: count do
      @res_group.recipes.each do |recipe|
        assert_select "a[href$=?]", recipe.id.to_s, text: recipe.name
      end
    end
  end

  test "should filter yields by group" do
    post filter_yields_path, res_group_id: @res_group.id
    assert_redirected_to res_group_res_yields_url(@res_group)
    follow_redirect!
    assert_template 'res_yields/index'

    r_y_count = ResYield.where(recipe: @res_group.recipes).count
    count = r_y_count < ResYield.per_page ? r_y_count : ResYield.per_page
    count += 1 # with 'Recipes' link

    assert_select "a[href^=?]", recipes_path, count: count
  end

  test "should filter yields by recipe" do
    recipe = recipes(:r_two_for_user_one)
    post filter_yields_path, recipe_id: recipe.id
    assert_redirected_to recipe_res_yields_url(recipe)
    follow_redirect!
    assert_template 'res_yields/index'

    r_y_count = recipe.res_yields.count
    count = r_y_count < ResYield.per_page ? r_y_count : ResYield.per_page

    # to skip pagination and sidebar links restrict within the 'table' element:
    assert_select "table a[href^=?]", recipes_path, count: count
  end



end
