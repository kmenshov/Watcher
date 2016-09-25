class ResGroup < ActiveRecord::Base
  belongs_to :user
  has_many :recipes
  has_many :res_yields, through: :recipes

  validates :name, presence: true, exclusion: { in: Rails.configuration.res_group_reserved_names }
  validates :user, presence: true

  before_destroy :ensure_default_group


#  def default_group
#    @default_group ||= User.find_by_id(self.user_id).find_by_name(Rails.configuration.res_group_reserved_names[0])
#  end

  def default_group?
    self.user.default_group && (self.id == self.user.default_group.id)
  end

  def self.available_groups_for(user, other_user_id: nil)
    u = User.available_users_for(user)
    u = u.where(id: other_user_id) if other_user_id
    ResGroup.where(user_id: u)
  end


  private

    def ensure_default_group
      if recipes.any?
        if self.default_group? || self.user.default_group.nil?
          recipes.destroy_all
        else
          recipes.update_all(res_group_id: self.user.default_group.id)
        end
      end
    end

end
