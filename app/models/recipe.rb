class Recipe < ActiveRecord::Base
  belongs_to :res_group

  validates :name, :url, :content, presence: true
  validates :res_group_id, inclusion: { in: ResGroup.this_user_groups_pluck(self, :id) }

end
