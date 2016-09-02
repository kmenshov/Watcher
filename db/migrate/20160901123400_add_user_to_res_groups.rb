class AddUserToResGroups < ActiveRecord::Migration
  def change
    add_reference :res_groups, :user, index: true, foreign_key: true
  end
end
