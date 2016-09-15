module FetchGroups
  extend ActiveSupport::Concern

  #included do
  #  a_class_method
  #end

private

  def set_res_groups_list_for(user, add_all: false)
    @res_groups_list = ResGroup.available_groups_for(user).pluck(:name, :id)
    @res_groups_list.unshift(["All groups", "all"]) if add_all
  end

  def set_recipes_list_for(user, add_all: false, res_group_id: nil)
    @recipes_list = Recipe.available_recipes_for(user, res_group_id: res_group_id).pluck(:name, :id)
    @recipes_list.unshift(["All recipes", "all"]) if add_all
  end

  #module ClassMethods
  #  def a_class_method
  #    puts "a_class_method called"
  #  end
  #end
end