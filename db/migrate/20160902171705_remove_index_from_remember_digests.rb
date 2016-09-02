class RemoveIndexFromRememberDigests < ActiveRecord::Migration
  def change
    remove_index :remember_digests, column: :remember_digest
  end
end
