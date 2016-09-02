class ResYieldsController < ApplicationController
  rescue_from (ActiveRecord::RecordNotFound) { |e| redirect_to res_yields_url }

  include FetchGroups

  before_action except: [:show, :rewatch] { set_res_groups_list(add_all: true) }

  def index
    @res_yields = ResYield.order(created_at: :desc)
    set_recipes_list(add_all: true)
  end

  def res_group_res_yields
    @res_yields = ResYield.available_yields(res_group_id: params[:res_group_id])
    set_recipes_list(add_all: true, res_group_id: params[:res_group_id])
    render :index
  end

  def recipe_res_yields
    @res_yields = ResYield.available_yields(recipe_id: params[:recipe_id])
    set_recipes_list(add_all: true)
    render :index
  end

  def show
    @res_yield = ResYield.find(params[:id])
    @res_yield.update(read: true)
  end

end
