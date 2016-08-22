class Recipe < ActiveRecord::Base
  require 'open-uri'

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

  #check the page from self.url to see which yields it produces right now
  def see_yields
    obtained_yields = []

    begin
      document = Nokogiri::HTML(open self.url)
      white_list_sanitizer = Rails::Html::WhiteListSanitizer.new

      document.css(self.content).each do |element|
        obtained_yields << white_list_sanitizer.sanitize(element.to_html)
      end
    rescue
      obtained_yields << 'Parsing error'
    end

    obtained_yields
  end

  private

    def ensure_proper_group_id
      unless ResGroup.available_groups.ids.include? self.res_group_id
        self.res_group_id = ResGroup.default_group.id
      end
    end

end
