class ResGroup < ActiveRecord::Base
  has_many :recipes
  has_many :res_yields, through: :recipes

  validates :name, presence: true, exclusion: { in: Rails.configuration.res_group_reserved_names }

  before_destroy :ensure_default_group


  def self.default_group
  #TODO: add a user constraint here
    ResGroup.find_by_name(Rails.configuration.res_group_reserved_names[0])
  end

  def self.available_groups
  #TODO: add a user constraint here
    ResGroup.all
  end


  private

    def ensure_default_group
      if recipes.any?
        recipes.update_all(res_group_id: ResGroup.default_group.id)
      end
    end

end
