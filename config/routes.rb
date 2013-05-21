CreateAndShare::Application.routes.draw do

  root :to => 'logs#new', :as => :login

  match '/logout' => 'logs#out', :as => :logout
  match '/login' => redirect('/')

  resources :logs, :only => [:new, :create]
  resources :users
  resources :posts

  # TODO - GATE THESE PAGES BY NESTING THE ROUTES
  match 'submit' => 'posts#new', :as => :real_submit_path
  match '/show/:id' => 'posts#show', :constraints => { :id => /\d+/ }
  match '/show/:atype' => 'posts#filter', :constraints => { :atype => /(cat|dog|other)s?/ }, :run => 'animal'
  match '/show/:state' => 'posts#filter', :constraints => { :state => /[A-Z]{2}/ }, :run => 'state'
  match '/show/:atype-:state' => 'posts#filter', :constraints => { :atype => /(cat|dog|other)s?/, :filter => /[A-Z]{2}/ }, :run => 'both'
  match '/show/featured' => 'posts#filter', :run => 'featured'
  match '/autoimg' => 'posts#autoimg'
  match '/alterimg/:id' => 'posts#alterimg', :as => :alter_image

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
