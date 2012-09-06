Race::Application.routes.draw do
  devise_for :accounts

  # character and models a character can belong to
  resources  :characters, :corporations, :alliances

  # resources directly associated with the EVE api
  resources :industry_jobs, :contracts, :eve_notifications,
    :eve_mails, :mailing_lists, :eve_assets, :market_orders, :wallet_journals,
    :wallet_transactions, :skills

  # Fittings and associated controllers
  resources :fittings

  # Logistics and everything associated with it
  resources :logistics_orders

  resources :registration

  # alternative route for adding new characters (aka character registration)
  get "characters/add" => 'characters#new', :as => 'characters/add'
  
  # Route for changing the main character of an account
  get "accounts/change_main_character/:id" => 'accounts#change_main_character', :as => 'change_main_character'
  
  get "characters/skills" => 'skills#index'
  get "characters/new" => "characters#new", :as => "new_characters"
  post "characters/update" => "characters#update"
  
  # search and autocomplete routes
  post "search/autocomplete"
  
  # set site root
  root :to => 'application#index', :as => 'root'

  mount Resque::Server, :at => "/resque"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:key => "value", 
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
