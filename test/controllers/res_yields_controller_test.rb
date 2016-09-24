require 'test_helper'

class ResYieldsControllerTest < ActionController::TestCase
  setup do
    @user_one   = users(:user_one)
    @admin      = users(:admin)
    @res_yield  = res_yields(:res_yield_one_2) #don't know why the second exactly. Just for fun.
  end

# --- Index ---

  def assert_first_page_with_pagination
    get :index

    assert_select 'div.pagination', count: 2

    count = ResYield.per_page
    r_y_path = res_yields_path + '/'
    assert_select "a[href*=?]", r_y_path, count: count

    g = ResGroup.where(user_id: @user_one)
    r = Recipe.where(res_group_id: g)
    res_yields = ResYield.where(recipe_id: r)

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
    assert_first_page_with_pagination
  end

  test "should get first page with pagination for admin" do
    login_as @admin
    assert_first_page_with_pagination
  end

  test "should not get yields for others" do
    login_as users(:user_two)
    get :index
    assert_response :success
    assert_template 'res_yields/index'

    assert_select 'div.pagination', false         #no pagination divs

    r_y_path = res_yields_path + '/'
    assert_select "a[href*=?]", r_y_path, false   #not a single res_yield
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
    login_as @user_one

    yields_total  = ResYield.all.count
    per_page      = ResYield.per_page
    full_pages    = yields_total / per_page
    tested_page   = rand(1..full_pages)

    assert_equal yields_total, ResYield.where(read: false).count

    post :mark, mark_page_read: 'anything', page: tested_page.to_s
    assert_redirected_to res_yields_url

    assert_equal per_page, ResYield.where(read: true).count
    assert_equal yields_total - per_page, ResYield.where(read: false).count

    ResYield.all.order(created_at: :desc)
            .offset((tested_page - 1) * per_page)
            .limit(per_page).each do |res_yield|
      assert res_yield.read?
    end
  end

  test "should mark all as read" do
    login_as @user_one

    yields_total  = ResYield.all.count
    assert_equal yields_total, ResYield.where(read: false).count

    post :mark, mark_all_read: 'anything', page: '1'
    assert_redirected_to res_yields_url

    assert_equal yields_total, ResYield.where(read: true).count
  end

end
