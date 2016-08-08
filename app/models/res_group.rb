class ResGroup < ActiveRecord::Base
  has_many :recipes

  validates :name, presence: true, exclusion: { in: Rails.configuration.res_group_reserved_names }

#  before_destroy :ensure_default_group

  def self.this_user_groups_pluck(user, *fields)
  # I should add a constraint here to only return those groups that belong to the given user
    pluck(*fields)
  end


  private

#    def ensure_default_group
#    end

end
