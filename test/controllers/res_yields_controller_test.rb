require 'test_helper'

class ResYieldsControllerTest < ActionController::TestCase
  setup do
    @user_one   = users(:user_one)
    @admin      = users(:admin)
    @res_yield  = res_yields(:res_yield_one_2) #don't know why the second exactly. Just for fun.
  end

# --- Index ---

  def assert_first_page_with_pagination(res_groups)
    get :index

    assert_select 'div.pagination', count: 2

    r_y_path = res_yields_path + '/'
    assert_select "a[href*=?]", r_y_path, count: ResYield.per_page

    r = Recipe.where(res_group: res_groups)
    res_yields = ResYield.where(recipe: r)

    res_yields.order(created_at: :desc).paginate(page: 1).each do |res_yield|
      assert_select "a[href=?]", res_yield_path(res_yield)
    end
  end

  test "should get index for logged in" do
    login_as @user_one
    get :index
    assert_response :success
    assert_not_nil assigns(:res_yields)
    assert_template 'res_yields/index'
  end

  test "should not get yields for not logged in" do
    get :index
    assert_login_required
  end

  test "should get first page with pagination" do
    login_as @user_one
    assert_first_page_with_pagination @user_one.res_groups
  end

  test "should get first page with pagination for admin" do
    login_as @admin
    assert_first_page_with_pagination ResGroup.all
  end

  test "should not get yields for others" do
    login_as users(:user_three)
    get :index
    assert_response :success
    assert_template 'res_yields/index'

    assert_select 'div.pagination', false         #no pagination divs

    r_y_path = res_yields_path + '/'
    assert_select "a[href*=?]", r_y_path, false   #not a single res_yield
  end

  test "should filter res_yields by group" do
    login_as @user_one
    res_group   = res_groups(:group_one_for_user_one)
    recipes     = Recipe.where(res_group: res_group)
    res_yields  = ResYield.where(recipe: recipes)

    get :index, res_group_id: res_group.id
    assert_response :success
    assert_template 'res_yields/index'

    assert_equal  assigns(:res_yields).pluck(:id),
                  res_yields.order(created_at: :desc).paginate(page: 1).pluck(:id)
  end

  test "should filter res_yields by recipe" do
    login_as @user_one
    recipe     = recipes(:r_three_for_user_one)
    res_yields = ResYield.where(recipe: recipe)

    get :index, recipe_id: recipe.id
    assert_response :success
    assert_template 'res_yields/index'

    assert_equal  assigns(:res_yields).pluck(:id),
                  res_yields.order(created_at: :desc).paginate(page: 1).pluck(:id)
  end

# --- Show ---

  test "should show own res_yield" do
    login_as @user_one
    get :show, id: @res_yield
    assert_response :success
    assert_template 'res_yields/show'
  end

  test "should show res_yield for admins" do
    login_as @admin
    get :show, id: @res_yield
    assert_response :success
    assert_template 'res_yields/show'
  end

  test "should not show res_yield for others" do
    login_as users(:user_two)
    get :show, id: @res_yield
    assert_redirected_with_flash_to root_url
  end

  test "should not show res_yield for not logged in" do
    get :show, id: @res_yield
    assert_login_required
  end

  test "should mark res_yield as read when viewing" do
    login_as @user_one
    refute @res_yield.read? #just to be shure
    get :show, id: @res_yield
    assert @res_yield.reload.read?
  end

# --- Mark ---

  test "should not mark as read for not logged in" do
    post :mark, mark_page_read: 'anything', page: '1'
    assert_login_required

    post :mark, mark_all_read: 'anything', page: '1'
    assert_login_required
  end

  test "should mark page as read" do
    assert_equal ResYield.all.count, ResYield.where(read: false).count

    login_as @user_one

    yields_total  = ResYield.where(recipe: Recipe.where(res_group: @user_one.res_groups))
    per_page      = ResYield.per_page
    full_pages    = yields_total.count / per_page
    tested_page   = rand(1..full_pages)

    post :mark, mark_page_read: 'anything', page: tested_page.to_s
    assert_redirected_to res_yields_url

    assert_equal per_page, ResYield.where(read: true).count
    # I know the next one is redundant, but I just can't help myself.
    # After all it's just one more assertion, right?
    # So, for the sake of thoroughness:
    assert_equal ResYield.all.count - per_page, ResYield.where(read: false).count

    yields_total.order(created_at: :desc)
            .offset((tested_page - 1) * per_page)
            .limit(per_page).each do |res_yield|
      assert res_yield.read?
    end
  end

  test "should mark all as read" do
    assert_equal ResYield.all.count, ResYield.where(read: false).count

    login_as @user_one
    post :mark, mark_all_read: 'anything', page: '1'
    assert_redirected_to res_yields_url

    res_yields = ResYield.where(recipe: Recipe.where(res_group: @user_one.res_groups))
    assert_equal res_yields.count, ResYield.where(read: true).count
  end

end
