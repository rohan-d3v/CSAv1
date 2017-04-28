CSA::Application.routes.draw do
  get "forum/index", :as => "forum"
  get "notes/index", :as => "notes"
  get "calculator/index", :as => "calculator"
  get "reservation/index", :as => "reservation"
  get "practice/index", :as => "practice"
  get "chat/index", :as => "chat"


  # The priority is based upon order of creation:
  # first created -> highest priority.
  	match "/people/login/" => "people#login"
  	match "/people/logout/" => "people#logout"
	resources :people, :tags, :feeds
  resources :missions, :id => /[0-9]*/ do
    collection do
      get :autocomplete_person_name
      get 'list'
    end

    member do
      get 'attendance'
      get 'feeds'
      get 'points'
      post 'points' => 'missions#save_points'
    end
  end
	resources :players, :as => :registrations, :controller => :registrations, :id=>/[0-9]*/ do
	end
 
  resources :games do
    collection do
      post 'update_current'
    end

    member do
      get 'tools'
      get 'rules'
      get 'tree'
      get 'heatmap'
      get 'emails'
      get 'text'
      post 'text' => 'games#text_create'
      get 'admin_register' => 'games#admin_register_new'
      post 'admin_register' => 'games#admin_register_create'
    end
  end

  get '/contact' => 'contact_messages#new'
	resources :contact, :as => :contact_messages, :controller => :contact_messages do
		collection do
			get :list
		end
	end

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
  root :to => "index#root"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
