class AddNotNullToRecipes < ActiveRecord::Migration
  def change
    change_column_null :recipes, :name, false
    change_column_null :recipes, :url, false
    change_column_null :recipes, :content, false
  end
end
