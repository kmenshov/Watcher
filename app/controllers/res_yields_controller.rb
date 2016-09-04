class ResYieldsController < ApplicationController
  #rescue_from (ActiveRecord::RecordNotFound) { |e| redirect_to res_yields_url }

  include FetchGroups

  def index
    set_res_groups_list_for(current_user, add_all: true)
    set_recipes_list_for(current_user, add_all: true, res_group_id: params[:res_group_id])

    @res_yields = ResYield.available_yields_for(current_user,
                          res_group_id: params[:res_group_id],
                          recipe_id: params[:recipe_id]).
                          order(created_at: :desc).
                          page(params[:page])
  end

  def show
    @res_yield = ResYield.available_yields_for(current_user).find_by_id(params[:id])
    if @res_yield
      @res_yield.update(read: true)
    else
      redirect_back_or_default(alert: 'Yield not found or access denied.')
    end
  end

end
