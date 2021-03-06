Whichizrite::Application.routes.draw do
  # mount Ckeditor::Engine => '/ckeditor'

  devise_for :users, :path => '', :path_names => {:sign_in => "login", :sign_out => "logout",
                                                  :sign_up => "register"},
                      :controllers => {:registrations => "users/registrations",
                                       :omniauth_callbacks => "users/omniauth_callbacks"}

  devise_scope :user do
    get "login",    :to => "users/sessions#new"
    get "logout",   :to => "users/sessions#destroy"
    get "register", :to => "users/registrations#new"
    get "delete",   :to => "users/registrations#destroy"
    get "settings", :to => "users/registrations#edit"
    get "settings/password", :to => "users/registrations#password"
    patch "settings/password" => "users/registrations#settings_password"
    put "settings/password" => "users/registrations#settings_password"
    get "settings/privacy", :to => "users/registrations#privacy"
    patch "settings/privacy" => "users/registrations#settings_privacy"
    put "settings/privacy" => "users/registrations#settings_privacy"
  end 

  get 'feed', to: 'pages#feed'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  resources :users do
    member do
      get :follow
      get :unfollow
      get :followers
      get :following
      get :visibility
      get :unpend
    end
  end

  # resource :user, only: [:show] do
  #   collection do
  #     patch 'settings_password'
  #   end
  # end
  
  resources :pages

  resources :posts do
    member do
      get :vote_up
      get :vote_down
      get :unvote
      get :comment
    end
  end

  resources :comments do
    member do
      get :vote_up
      get :vote_down
      get :unvote
    end
  end
  resources :votes

  get 'categories/:category', to: 'posts#index', as: :category

  get 'tags/:tag', to: 'posts#index', as: :tag

  root :to => 'pages#home'

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
