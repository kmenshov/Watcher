class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :url
      t.string :content
      t.references :res_group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
