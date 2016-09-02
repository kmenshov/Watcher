class CreateRememberDigests < ActiveRecord::Migration
  def change
    create_table :remember_digests do |t|
      t.string :remember_digest, index: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
