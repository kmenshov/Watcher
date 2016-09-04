class RedirectsController < ApplicationController

  def filter_recipes
    if params[:res_group_id].to_i != 0
      redirect_to res_group_recipes_url(params[:res_group_id])
    else
      redirect_to recipes_url
    end
  end

  def filter_yields
    if params[:recipe_id].to_i != 0
      redirect_to recipe_res_yields_url(params[:recipe_id])
    elsif params[:res_group_id].to_i != 0
      redirect_to res_group_res_yields_url(params[:res_group_id])
    else
      redirect_to res_yields_url
    end
  end

end
