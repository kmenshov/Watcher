class RecipesController < ApplicationController
  #rescue_from (ActiveRecord::RecordNotFound) { |e| redirect_to recipes_url }

  include FetchGroups

  #'create' and 'update' are needed too in case of redirections after failed validations:
  before_action only: [:new, :edit, :create, :update] { set_res_groups_list_for(current_user) }
  before_action only: [:index]                        { set_res_groups_list_for(current_user, add_all: true) }

  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.available_recipes_for(current_user, res_group_id: params[:res_group_id])
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if params[:preview_button]
        @recipe.valid?
      elsif @recipe.save
        format.html { redirect_to @recipe, flash: { success: 'Recipe was successfully created.' } }
        format.json { render :show, status: :created, location: @recipe }
      end
      format.html { render :new }
      format.json { render json: @recipe.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if params[:preview_button]
        @recipe.assign_attributes(recipe_params)
        @recipe.valid?
      elsif @recipe.update(recipe_params)
        format.html { redirect_to @recipe, flash: { success: 'Recipe was successfully updated.' } }
        format.json { render :show, status: :ok, location: @recipe }
      end
      format.html { render :edit }
      format.json { render json: @recipe.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, flash: { success: 'Recipe was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.available_recipes_for(current_user).find_by_id(params[:id])
      redirect_back_or_default(default: recipes_url, flash: { danger: 'Recipe not found or access denied.' }) unless @recipe
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      # ensure correct group:
      unless ResGroup.available_groups_for(current_user).pluck(:id).include? params[:recipe][:res_group_id].to_i
        params[:recipe][:res_group_id] = current_user.default_group.id
      end

      params.require(:recipe).permit(:name, :url, :content, :res_group_id)
    end
end
