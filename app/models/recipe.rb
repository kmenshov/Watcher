class Recipe < ActiveRecord::Base
  belongs_to :res_group
  has_many :res_yields

  validates :name, :url, :content, presence: true
  #validates :res_group_id, inclusion: { in: ResGroup.list_for('user', :id) } #add a user as a parameter here


  def res_group_name
    self.res_group ? self.res_group.name : ResGroup.default_group.name
  end

  def res_group_name=(name)
    self.res_group_id = if ResGroup.available_names.include? name
      #TODO: add user constraint here (two different users may have the same names for their groups)
      ResGroup.find_by_name(name).id
    else
      ResGroup.default_group.id
    end
  end

end
