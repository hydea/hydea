Rails.application.routes.draw do
  resources :likes, only: [:create, :destroy]
  resources :tags
  resources :comments
  resources :ideas
  resources :histories
  resources :users

  root 'ideas#index'

  # Hydea specific
  resource :session, only: [:new, :create, :destroy]
  delete 'logout', to: 'sessions#destroy'
  resources :ideas do
	  post 'publish', on: :member
    post 'publish_moderate', on: :member
    post 'moderate', on: :member
    post 'un_moderate', on: :member
    post 'reject', on: :member
    post 'changing', on: :member
    post 'changed', on: :member
    post 'not_changed', on: :member
    post 'like', on: :member
    post 'unlike', on: :member
  end

  resources :comments do
	  post 'publish', on: :member
    post 'unpublish', on: :member
  end

  #SAML Authentication
  namespace :haka do
    get 'auth/new'
    get 'auth/consume'
    post 'auth/consume'    
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
