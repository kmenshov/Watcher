class ResYieldsController < ApplicationController
  rescue_from (ActiveRecord::RecordNotFound) { |e| redirect_to res_yields_url }

  def index
    if params[:res_group_id].to_i != 0
      @res_yields = ResGroup.find(params[:res_group_id]).res_yields
    elsif params[:recipe_id].to_i != 0
      @res_yields = Recipe.find(params[:recipe_id]).res_yields
    else
      @res_yields = ResYield.all
    end
  end

  def show
    @res_yield = ResYield.find(params[:id])
    @res_yield.update(read: true)
  end

#does rewatch (update) for all recipes
  def rewatch
  end
end
