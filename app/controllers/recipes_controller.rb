class RecipesController < ApplicationController
  rescue_from (ActiveRecord::RecordNotFound) { |e| redirect_to recipes_url }

  include FetchGroups

  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  #'create' and 'update' are needed too in case of redirections after failed validations:
  before_action only: [:new, :edit, :create, :update] { set_res_groups_list }
  before_action only: [:index, :res_group_recipes] { set_res_groups_list(add_all: true) }

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.all
  end

  def res_group_recipes
    @recipes = Recipe.available_recipes(res_group_id: params[:res_group_id])
    render :index
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
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:name, :url, :content, :res_group_id)
    end
end
