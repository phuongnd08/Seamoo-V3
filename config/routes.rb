SeamooV3::Application.routes.draw do
  scope "(:locale)", :locale => /en|vi/ do
    resources :follow_patterns, :except => [:index, :destroy]

    resources :multiple_choices, :except => [:index, :destroy]

    resources :questions, :except => [:update]

    resources :home, :only => [:index] do
      collection do
        get :secured
      end
    end

    resources :categories
    resources :leagues do
      member do
        get :matching
        post :request_match
        post :leave_current_match
      end
    end

    resources :matches, :only => [:index, :show] do
      member do
        post :infor
        post :submit_answer
        post :more_questions
      end
    end

    match 'signin' => 'user_sessions#new', :as => :signin
    match 'signout' => 'user_sessions#destroy', :as => :signout
  end

  root :to => "home#index"
  match "/:locale" => "home#index"
  match "/auth/:provider/callback" => "authorizations#create"
  match "/auth/failure" => "authorizations#failure"
  match "/auth/signin/:username" => "authorizations#signin"


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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
