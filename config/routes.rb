Rails.application.routes.draw do

  get 'sessions/new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users do
    member do
      get 'to_authenticate'
      get 'to_revoke'
    end
  end

  get 'register', to: 'users#new', as: 'register'
  # user_registration_test.rb dependent on register_path too

  root 'pages#home'

  get 'pages/profile'

  get 'calendar', to: 'pages#calendar', as: 'calendar'

  get 'pages/tasks'

  get 'files', to: 'pages#files', as: 'files'

  # get 'pages/contacts'
  # resources :contacts

  #not in use currently
  # get 'google-calendar', to: 'pages#google_calendar'
  # get 'google-drive', to: 'pages#google_drive'
  # get 'pages/calendar-callback', to: 'pages#calendar_callback'
  # get 'pages/drive-callback', to: 'pages#drive_callback'

  resources :groups do
    resources :memberships, only: [:index, :create, :destroy, :update]
    resources :categories, path: 'c' do
      resources :tasks
      resource :text_page, only: [:create, :new, :show, :update, :edit]
      get 'text_page/to_authenticate', to: 'text_pages#to_authenticate', as: 'text_page_auth'
      resources :contacts
      resource :calendar, only: [:create, :new, :show, :update, :edit]
      resources :events
      get 'calendar/to_authenticate', to: 'calendars#to_authenticate', as: 'calendar_auth'
      post 'calendar/show_period', to: 'calendars#show_period', as: 'calendar_period'
      get 'events/google_edit/:id', to: 'events#google_edit', as: 'edit_google_event'

      get 'events/google/:id', to: 'events#google_show', as: 'google_event'
      post 'events/google/:id', to: 'events#google_update'
      delete 'events/google/:id', to: 'events#google_destroy'
      post 'events/index_period', to: 'events#index_period', as: 'events_period'
      post 'events/export_event/:id', to: 'events#export_event', as: 'export_event'
      post 'events/export_all_events', to: 'events#export_all_events', as: 'export_all_events'
    end
    post '/categories_save_order', to: 'categories#saveOrder', as: 'categories_save_order'
  end

  post '/join_group/:id', to: 'groups#join', as: 'join_group'

  get '/auth/:provider/callback', to: 'sessions#auth_callback', as: 'auth_callback'
  post 'register_with_google', to: 'sessions#register_with_google', as: 'register_with_google'
  post 'login_with_google', to: 'sessions#login_with_google', as: 'login_with_google'

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
