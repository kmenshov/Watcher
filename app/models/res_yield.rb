class ResYield < ActiveRecord::Base
  belongs_to :recipe

  def self.available_yields(res_group_id: nil, recipe_id: nil)
  #TODO: add a user constraint here
    if res_group_id
      ResGroup.find(res_group_id).res_yields
    elsif recipe_id
      Recipe.find(recipe_id).res_yields
    else
      ResYield.all
    end
  end

end
