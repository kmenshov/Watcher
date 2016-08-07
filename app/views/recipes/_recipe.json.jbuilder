json.extract! recipe, :id, :name, :url, :content, :res_group_id, :created_at, :updated_at
json.url recipe_url(recipe, format: :json)