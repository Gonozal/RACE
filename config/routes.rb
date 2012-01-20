Race::Application.routes.draw do
  resources :skills

  match 'register' => 'accounts#new', :as => 'register'
  # alternative route for adding new characters (aka character registration)
  get "characters/add" => 'characters#new', :as => 'characters/add'
  get "login" => "sessions#new", :as => "login"
  get "logout" => "sessions#destroy", :as => "logout"
  get "registration" => "accounts#new", :as => "registration"
  
  # routes for the "forgot password" and "reset password" functionality
  get 'forget' => 'forget#show', :as => "forget"
  post 'forget' => 'forget#mail'
  get 'forget/:reset_hash' => 'forget#reset'
  post 'forget/:reset_hash' => 'forget#update'
  
  # Route for changing the main character of an account
  get "accounts/change_main_character/:id" => 'accounts#change_main_character', :as => 'change_main_character'
  
  get "characters/skills" => 'skills#index'
  
  get "characters/edit" => "characters#edit", :as => "edit_characters"
  post "characters/update" => "characters#update"
  
  # search and autocomplete routes
  post "search/autocomplete"
  
  get "accounts/edit" => "accounts#edit", :as => "edit_accounts"
  post "accounts/update" => "accounts#update"
  
  # set site root
  root :to => 'application#index', :as => 'root'

  resources :accounts, :characters, :sessions, :corporations

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
