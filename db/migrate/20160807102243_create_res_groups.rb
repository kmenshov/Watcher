class CreateResGroups < ActiveRecord::Migration
  def change
    create_table :res_groups do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
