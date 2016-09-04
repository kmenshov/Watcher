class Recipe < ActiveRecord::Base
  require 'open-uri'

  belongs_to :res_group
  has_many :res_yields, dependent: :delete_all

  validates :name, :url, :content, presence: true
  validate :ensure_proper_group_id

  #check the page from self.url to see which yields it produces right now
  def see_yields
    obtained_yields = []
    user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36'

    begin
      document = Nokogiri::HTML(open(self.url, "User-Agent" => user_agent))
      white_list_sanitizer = Rails::Html::WhiteListSanitizer.new

      document.css(self.content).each do |element|
        obtained_yields << white_list_sanitizer.sanitize(element.to_html)
      end
    rescue => e
      obtained_yields << 'Parsing error'
      obtained_yields << e.inspect if Rails.configuration.res_yields_debug
    end

    obtained_yields
  end

  def user
    User.find_by_id(ResGroup.find_by_id(self.res_group_id).user_id)
  end

  def self.available_recipes_for(user, other_user_id: nil, res_group_id: nil)
    g = ResGroup.available_groups_for(user, other_user_id: other_user_id)
    g = g.where(id: res_group_id) if res_group_id
    Recipe.where(res_group_id: g)
  end

  #check all recipes' urls and add all new yields to the DB
  def self.rewatch
    #IMPROVE: replace with find_each when recipes count is > 1000
    Recipe.all.each do |recipe|
      r_id = recipe.id #cache id for the new_yields.reverse_each routine

      r_new_yields = recipe.see_yields
      r_existing_yields = recipe.res_yields.pluck(:content)
      r_new_yields = r_new_yields - r_existing_yields

      r_new_yields.reverse_each do |new_yield|
        ResYield.create(recipe_id: r_id, content: new_yield)
      end
    end
  end

  private

    def ensure_proper_group_id
      unless ResGroup.available_groups_for(self.user).ids.include? self.res_group_id
        self.res_group_id = self.default_group.id
      end
    end

end
