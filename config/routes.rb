Rails.application.routes.draw do

  resources :users

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :res_groups

  resources :recipes
  get 'res_groups/:res_group_id/recipes', to: 'recipes#res_group_recipes', as: :res_group_recipes

  resources :res_yields, only: [:index, :show]
  get 'recipes/:recipe_id/res_yields', to: 'res_yields#recipe_res_yields', as: :recipe_res_yields
  get 'res_groups/:res_group_id/res_yields', to: 'res_yields#res_group_res_yields', as: :res_group_res_yields


  #redirects for group and recipe filtering forms
  post 'filter_recipes_by_group', to: 'redirects#filter_recipes_by_group'
  post 'filter_yields_by_group', to: 'redirects#filter_yields_by_group'
  post 'filter_yields_by_recipe', to: 'redirects#filter_yields_by_recipe'


  root 'res_yields#index'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
