class CreateResYields < ActiveRecord::Migration
  def change
    create_table :res_yields do |t|
      t.text :content
      t.boolean :read, null: false, default: false
      t.references :recipe, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
