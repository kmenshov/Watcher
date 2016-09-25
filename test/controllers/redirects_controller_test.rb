require 'test_helper'

class RedirectsControllerTest < ActionController::TestCase

  setup do
    login_as users(:user_one)
    @incorrect_ids = [0, 'test', '', nil]
  end

# --- Filter_Recipes ---

  test "should not accept incorrect res_group_ids for recipes" do
    @incorrect_ids.each do |inc_res_g_id|
      post :filter_recipes, res_group_id: inc_res_g_id
      assert_redirected_to recipes_url
    end
  end

  test "should accept correct res_group_ids for recipes" do
    correct_res_group_id = ResGroup.limit(10).pluck(:id)

    correct_res_group_id.each do |c_res_g_id|
      post :filter_recipes, res_group_id: c_res_g_id
      assert_redirected_to res_group_recipes_url(c_res_g_id)
    end
  end

# --- Filter_Yields ---

  test "should not accept incorrect res_group_ids for res_yields" do
    @incorrect_ids.each do |inc_res_g_id|
      post :filter_yields, res_group_id: inc_res_g_id
      assert_redirected_to res_yields_url
    end
  end

  test "should accept correct res_group_ids for res_yields" do
    correct_res_group_id = ResGroup.limit(10).pluck(:id)

    correct_res_group_id.each do |c_res_g_id|
      post :filter_yields, res_group_id: c_res_g_id
      assert_redirected_to res_group_res_yields_url(c_res_g_id)
    end
  end


  test "should not accept incorrect recipe_ids for res_yields" do
    @incorrect_ids.each do |inc_rec_id|
      post :filter_yields, recipe_id: inc_rec_id
      assert_redirected_to res_yields_url
    end
  end

  test "should accept correct recipe_ids for res_yields" do
    correct_recipe_id = Recipe
                        .where(res_group: users(:user_one).res_groups)
                        .limit(10)
                        .pluck(:id)

    correct_recipe_id.each do |c_rec_id|
      post :filter_yields, recipe_id: c_rec_id
      assert_redirected_to recipe_res_yields_url(c_rec_id)
    end
  end

end
