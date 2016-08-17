module FetchGroups
  extend ActiveSupport::Concern

  #included do
  #  a_class_method
  #end

private

  def set_res_groups_list(add_all: false)
    @res_groups_list = ResGroup.available_groups.pluck(:name, :id)
    @res_groups_list.unshift(["All", "all"]) if add_all
  end

  def set_recipes_list(add_all: false, res_group_id: nil)
    @recipes_list = Recipe.available_recipes(res_group_id: res_group_id).pluck(:name, :id)
    @recipes_list.unshift(["All", "all"]) if add_all
  end

  #module ClassMethods
  #  def a_class_method
  #    puts "a_class_method called"
  #  end
  #end
end