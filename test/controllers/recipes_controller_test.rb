require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  setup do
    @user_one       = users(:user_one)
    @admin          = users(:admin)
    @recipe_one_one = recipes(:r_one_for_user_one)
  end

# --- Index ---

  test "should get index for own recipes" do
    login_as @user_one
    get :index
    assert_response :success
    assert_not_nil assigns(:recipes)
    assert_template 'recipes/index'

    groups = ResGroup.where(user: @user_one)
    recipes = Recipe.where(res_group: groups)
    count = recipes.count + 2 # with 'Recipes' and 'New Recipe' links

    assert_select "a[href^=?]", recipes_path, count: count do
      recipes.each do |recipe|
        assert_select "a[href$=?]", recipe.id.to_s, text: recipe.name
      end
    end
  end

  test "should get all recipes for admin" do
    login_as @admin
    get :index
    assert_response :success
    assert_not_nil assigns(:recipes)
    assert_template 'recipes/index'

    recipes = Recipe.all
    count = recipes.count + 2 # with 'Recipes' and 'New Recipe' links

    assert_select "a[href^=?]", recipes_path, count: count do
      recipes.each do |recipe|
        assert_select "a[href$=?]", recipe.id.to_s, text: recipe.name
      end
    end
  end

  test "should not get recipes for not logged in" do
    get :index
    assert_login_required
  end

# --- New ---

  test "should get new" do
    login_as @user_one
    get :new
    assert_response :success
    assert_template 'recipes/new'
  end

  test "should not get new for not logged in" do
    get :new
    assert_login_required
  end

# --- Create ---

  test "should create recipe" do
    login_as @user_one
    new_recipe_name = 'New Recipe'
    new_recipe_url = 'https://www.facebook.com/'
    new_recipe_content = 'New Content'
    group = res_groups(:group_one_for_user_one)
    assert_difference('Recipe.count') do
      post :create, recipe: { content: new_recipe_content,
                              name: new_recipe_name,
                              url: new_recipe_url,
                              res_group_id: group }
    end
    assert_redirected_to recipe_path(assigns(:recipe))
    assert Recipe.exists?(content: new_recipe_content,
                          name: new_recipe_name,
                          url: new_recipe_url,
                          res_group_id: group.id)
  end

  test "should not create recipe for not logged in" do
    group = res_groups(:group_one_for_user_one)
    assert_no_difference('Recipe.count') do
      post :create, recipe: { content: 'whatever',
                              name: 'whatever',
                              url: 'https://www.facebook.com/', # for possible validations to pass
                              res_group_id: group }
    end
    assert_login_required
  end

# --- Show ---

  test "should show own recipe" do
    login_as @user_one
    get :show, id: @recipe_one_one
    assert_response :success
    assert_template 'recipes/show'
  end

  test "should show recipe for admins" do
    login_as @admin
    get :show, id: @recipe_one_one
    assert_response :success
    assert_template 'recipes/show'
  end

  test "should not show recipe for others" do
    login_as users(:user_two)
    get :show, id: @recipe_one_one
    assert_redirected_with_flash_to recipes_url
  end

  test "should not show recipe for not logged in" do
    get :show, id: @recipe_one_one
    assert_login_required
  end

# --- Edit ---

  test "should get edit for own recipe" do
    login_as @user_one
    get :edit, id: @recipe_one_one
    assert_response :success
    assert_template 'recipes/edit'
  end

  test "should get edit recipe for admin" do
    login_as @admin
    get :edit, id: @recipe_one_one
    assert_response :success
    assert_template 'recipes/edit'
  end

  test "should not get edit recipe for others" do
    login_as users(:user_two)
    get :edit, id: @recipe_one_one
    assert_redirected_with_flash_to recipes_url
  end

  test "should not get edit recipe for not logged in" do
    get :edit, id: @recipe_one_one
    assert_login_required
  end

# --- Update ---

  test "should update own recipe" do
    login_as @user_one
    u_recipe_name = 'Updated Recipe'
    u_recipe_url = 'https://www.facebook.com/'
    u_recipe_content = 'Updated Content'
    group = res_groups(:group_one_for_user_one)
    patch :update, id: @recipe_one_one, recipe: { content: u_recipe_content,
                                        name: u_recipe_name,
                                        url: u_recipe_url,
                                        res_group_id: group }
    assert_redirected_to recipe_path(assigns(:recipe))
    @recipe_one_one.reload
    assert_equal @recipe_one_one.content, u_recipe_content
    assert_equal @recipe_one_one.name, u_recipe_name
    assert_equal @recipe_one_one.url, u_recipe_url
  end

  test "should update recipe by admin" do
    login_as @admin
    u_recipe_name = 'Updated Recipe'
    u_recipe_url = 'https://www.facebook.com/'
    u_recipe_content = 'Updated Content'
    group = res_groups(:group_one_for_user_one)
    patch :update, id: @recipe_one_one, recipe: { content: u_recipe_content,
                                        name: u_recipe_name,
                                        url: u_recipe_url,
                                        res_group_id: group }
    assert_redirected_to recipe_path(assigns(:recipe))
    @recipe_one_one.reload
    assert_equal @recipe_one_one.content, u_recipe_content
    assert_equal @recipe_one_one.name, u_recipe_name
    assert_equal @recipe_one_one.url, u_recipe_url
  end

  test "should not update recipe by others" do
    login_as users(:user_two)
    u_recipe_name = 'Updated Recipe'
    u_recipe_url = 'https://www.facebook.com/'
    u_recipe_content = 'Updated Content'
    group = res_groups(:group_one_for_user_one)
    patch :update, id: @recipe_one_one, recipe: { content: u_recipe_content,
                                        name: u_recipe_name,
                                        url: u_recipe_url,
                                        res_group_id: group }
    assert_redirected_with_flash_to recipes_url
    @recipe_one_one.reload
    assert_not_equal @recipe_one_one.content, u_recipe_content
    assert_not_equal @recipe_one_one.name, u_recipe_name
    assert_not_equal @recipe_one_one.url, u_recipe_url
  end

  test "should not update recipe by not logged in" do
    u_recipe_name = 'Updated Recipe'
    u_recipe_url = 'https://www.facebook.com/'
    u_recipe_content = 'Updated Content'
    group = res_groups(:group_one_for_user_one)
    patch :update, id: @recipe_one_one, recipe: { content: u_recipe_content,
                                        name: u_recipe_name,
                                        url: u_recipe_url,
                                        res_group_id: group }
    assert_login_required
    @recipe_one_one.reload
    assert_not_equal @recipe_one_one.content, u_recipe_content
    assert_not_equal @recipe_one_one.name, u_recipe_name
    assert_not_equal @recipe_one_one.url, u_recipe_url
  end

# --- Destroy ---

  test "should destroy own recipe" do
    login_as @user_one
    assert_difference('Recipe.count', -1) do
      delete :destroy, id: @recipe_one_one
    end
    assert_redirected_to recipes_url
  end

  test "should destroy recipe by admin" do
    login_as @admin
    assert_difference('Recipe.count', -1) do
      delete :destroy, id: @recipe_one_one
    end
    assert_redirected_to recipes_url
  end

  test "should not destroy recipe by others" do
    login_as users(:user_two)
    assert_no_difference('Recipe.count') do
      delete :destroy, id: @recipe_one_one
    end
    assert_redirected_with_flash_to recipes_url
  end

  test "should not destroy recipe by not logged in" do
    assert_no_difference('Recipe.count') do
      delete :destroy, id: @recipe_one_one
    end
    assert_login_required
  end

end
