class Recipe < ActiveRecord::Base
  belongs_to :res_group
  has_many :res_yields

  validates :name, :url, :content, presence: true
  validate :ensure_proper_group_id

  def self.available_recipes(res_group_id: nil)
  #TODO: add a user constraint here
    if res_group_id
      ResGroup.find(res_group_id).recipes
    else
      Recipe.all
    end
  end

  private

    def ensure_proper_group_id
      unless ResGroup.available_groups.ids.include? self.res_group_id
        self.res_group_id = ResGroup.default_group.id
      end
    end

end
