class Recipe < ActiveRecord::Base
  belongs_to :res_group
  has_many :res_yields

  validates :name, :url, :content, presence: true
  validates :res_group_id, inclusion: { in: ResGroup.this_user_groups_pluck('user', :id) } #add a user as a parameter here

end
