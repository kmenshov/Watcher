class ResYield < ActiveRecord::Base
  belongs_to :recipe

  def self.available_yields_for(user, other_user_id: nil, res_group_id: nil, recipe_id: nil)
    r = Recipe.available_recipes_for(user, other_user_id: other_user_id, res_group_id: res_group_id)
    r = r.where(id: recipe_id) if recipe_id
    ResYield.where(recipe_id: r)
  end

end
