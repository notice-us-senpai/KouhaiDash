# == Route Map
#
#                           Prefix Verb   URI Pattern                                                          Controller#Action
#                     sessions_new GET    /sessions/new(.:format)                                              sessions#new
#                            login GET    /login(.:format)                                                     sessions#new
#                                  POST   /login(.:format)                                                     sessions#create
#                           logout DELETE /logout(.:format)                                                    sessions#destroy
#             to_authenticate_user GET    /users/:id/to_authenticate(.:format)                                 users#to_authenticate
#                   to_revoke_user GET    /users/:id/to_revoke(.:format)                                       users#to_revoke
#                            users GET    /users(.:format)                                                     users#index
#                                  POST   /users(.:format)                                                     users#create
#                         new_user GET    /users/new(.:format)                                                 users#new
#                        edit_user GET    /users/:id/edit(.:format)                                            users#edit
#                             user GET    /users/:id(.:format)                                                 users#show
#                                  PATCH  /users/:id(.:format)                                                 users#update
#                                  PUT    /users/:id(.:format)                                                 users#update
#                                  DELETE /users/:id(.:format)                                                 users#destroy
#                         register GET    /register(.:format)                                                  users#new
#                             root GET    /                                                                    pages#home
#                    pages_profile GET    /pages/profile(.:format)                                             pages#profile
#                         calendar GET    /calendar(.:format)                                                  pages#calendar
#                      pages_tasks GET    /pages/tasks(.:format)                                               pages#tasks
#                            files GET    /files(.:format)                                                     pages#files
#                     group_string GET    /g/:string_id(.:format)                                              groups#show_by_string_id
#                    groups_search POST   /groups/search(.:format)                                             groups#search
#                group_memberships GET    /groups/:group_id/memberships(.:format)                              memberships#index
#                                  POST   /groups/:group_id/memberships(.:format)                              memberships#create
#                 group_membership PATCH  /groups/:group_id/memberships/:id(.:format)                          memberships#update
#                                  PUT    /groups/:group_id/memberships/:id(.:format)                          memberships#update
#                                  DELETE /groups/:group_id/memberships/:id(.:format)                          memberships#destroy
#         group_memberships_search POST   /groups/:group_id/memberships/search(.:format)                       memberships#search
#            group_memberships_add POST   /groups/:group_id/memberships/add_user/:user_id(.:format)            memberships#add_user
#             group_category_tasks GET    /groups/:group_id/c/:category_id/tasks(.:format)                     tasks#index
#                                  POST   /groups/:group_id/c/:category_id/tasks(.:format)                     tasks#create
#          new_group_category_task GET    /groups/:group_id/c/:category_id/tasks/new(.:format)                 tasks#new
#         edit_group_category_task GET    /groups/:group_id/c/:category_id/tasks/:id/edit(.:format)            tasks#edit
#              group_category_task GET    /groups/:group_id/c/:category_id/tasks/:id(.:format)                 tasks#show
#                                  PATCH  /groups/:group_id/c/:category_id/tasks/:id(.:format)                 tasks#update
#                                  PUT    /groups/:group_id/c/:category_id/tasks/:id(.:format)                 tasks#update
#                                  DELETE /groups/:group_id/c/:category_id/tasks/:id(.:format)                 tasks#destroy
#         group_category_text_page POST   /groups/:group_id/c/:category_id/text_page(.:format)                 text_pages#create
#     new_group_category_text_page GET    /groups/:group_id/c/:category_id/text_page/new(.:format)             text_pages#new
#    edit_group_category_text_page GET    /groups/:group_id/c/:category_id/text_page/edit(.:format)            text_pages#edit
#                                  GET    /groups/:group_id/c/:category_id/text_page(.:format)                 text_pages#show
#                                  PATCH  /groups/:group_id/c/:category_id/text_page(.:format)                 text_pages#update
#                                  PUT    /groups/:group_id/c/:category_id/text_page(.:format)                 text_pages#update
#    group_category_text_page_auth GET    /groups/:group_id/c/:category_id/text_page/to_authenticate(.:format) text_pages#to_authenticate
#          group_category_contacts GET    /groups/:group_id/c/:category_id/contacts(.:format)                  contacts#index
#                                  POST   /groups/:group_id/c/:category_id/contacts(.:format)                  contacts#create
#       new_group_category_contact GET    /groups/:group_id/c/:category_id/contacts/new(.:format)              contacts#new
#      edit_group_category_contact GET    /groups/:group_id/c/:category_id/contacts/:id/edit(.:format)         contacts#edit
#           group_category_contact GET    /groups/:group_id/c/:category_id/contacts/:id(.:format)              contacts#show
#                                  PATCH  /groups/:group_id/c/:category_id/contacts/:id(.:format)              contacts#update
#                                  PUT    /groups/:group_id/c/:category_id/contacts/:id(.:format)              contacts#update
#                                  DELETE /groups/:group_id/c/:category_id/contacts/:id(.:format)              contacts#destroy
#          group_category_calendar POST   /groups/:group_id/c/:category_id/calendar(.:format)                  calendars#create
#      new_group_category_calendar GET    /groups/:group_id/c/:category_id/calendar/new(.:format)              calendars#new
#     edit_group_category_calendar GET    /groups/:group_id/c/:category_id/calendar/edit(.:format)             calendars#edit
#                                  GET    /groups/:group_id/c/:category_id/calendar(.:format)                  calendars#show
#                                  PATCH  /groups/:group_id/c/:category_id/calendar(.:format)                  calendars#update
#                                  PUT    /groups/:group_id/c/:category_id/calendar(.:format)                  calendars#update
#            group_category_events GET    /groups/:group_id/c/:category_id/events(.:format)                    events#index
#                                  POST   /groups/:group_id/c/:category_id/events(.:format)                    events#create
#         new_group_category_event GET    /groups/:group_id/c/:category_id/events/new(.:format)                events#new
#        edit_group_category_event GET    /groups/:group_id/c/:category_id/events/:id/edit(.:format)           events#edit
#             group_category_event GET    /groups/:group_id/c/:category_id/events/:id(.:format)                events#show
#                                  PATCH  /groups/:group_id/c/:category_id/events/:id(.:format)                events#update
#                                  PUT    /groups/:group_id/c/:category_id/events/:id(.:format)                events#update
#                                  DELETE /groups/:group_id/c/:category_id/events/:id(.:format)                events#destroy
#     group_category_calendar_auth GET    /groups/:group_id/c/:category_id/calendar/to_authenticate(.:format)  calendars#to_authenticate
#   group_category_calendar_period POST   /groups/:group_id/c/:category_id/calendar/show_period(.:format)      calendars#show_period
# group_category_edit_google_event GET    /groups/:group_id/c/:category_id/events/google_edit/:id(.:format)    events#google_edit
#      group_category_google_event GET    /groups/:group_id/c/:category_id/events/google/:id(.:format)         events#google_show
#                                  POST   /groups/:group_id/c/:category_id/events/google/:id(.:format)         events#google_update
#                                  DELETE /groups/:group_id/c/:category_id/events/google/:id(.:format)         events#google_destroy
#     group_category_events_period POST   /groups/:group_id/c/:category_id/events/index_period(.:format)       events#index_period
#      group_category_export_event POST   /groups/:group_id/c/:category_id/events/export_event/:id(.:format)   events#export_event
# group_category_export_all_events POST   /groups/:group_id/c/:category_id/events/export_all_events(.:format)  events#export_all_events
#                 group_categories GET    /groups/:group_id/c(.:format)                                        categories#index
#                                  POST   /groups/:group_id/c(.:format)                                        categories#create
#               new_group_category GET    /groups/:group_id/c/new(.:format)                                    categories#new
#              edit_group_category GET    /groups/:group_id/c/:id/edit(.:format)                               categories#edit
#                   group_category GET    /groups/:group_id/c/:id(.:format)                                    categories#show
#                                  PATCH  /groups/:group_id/c/:id(.:format)                                    categories#update
#                                  PUT    /groups/:group_id/c/:id(.:format)                                    categories#update
#                                  DELETE /groups/:group_id/c/:id(.:format)                                    categories#destroy
#      group_categories_save_order POST   /groups/:group_id/categories_save_order(.:format)                    categories#saveOrder
#                           groups GET    /groups(.:format)                                                    groups#index
#                                  POST   /groups(.:format)                                                    groups#create
#                        new_group GET    /groups/new(.:format)                                                groups#new
#                       edit_group GET    /groups/:id/edit(.:format)                                           groups#edit
#                            group GET    /groups/:id(.:format)                                                groups#show
#                                  PATCH  /groups/:id(.:format)                                                groups#update
#                                  PUT    /groups/:id(.:format)                                                groups#update
#                                  DELETE /groups/:id(.:format)                                                groups#destroy
#                       join_group POST   /join_group/:id(.:format)                                            groups#join
#                    auth_callback GET    /auth/:provider/callback(.:format)                                   sessions#auth_callback
#             register_with_google POST   /register_with_google(.:format)                                      sessions#register_with_google
#                login_with_google POST   /login_with_google(.:format)                                         sessions#login_with_google
#

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
  get 'g/:string_id', to: 'groups#show_by_string_id', as:'group_string'
  post 'groups/search', to: 'groups#search', as: 'groups_search'
  resources :groups do
    resources :memberships, only: [:index, :create, :destroy, :update]
    post 'memberships/search', to: 'memberships#search', as: 'memberships_search'
    post 'memberships/add_user/:user_id', to: 'memberships#add_user', as: 'memberships_add'
    resources :categories, path: 'c' do
      resources :tasks
      resource :text_page, only: [:create, :new, :show, :update, :edit]
      get 'text_page/to_authenticate', to: 'text_pages#to_authenticate', as: 'text_page_auth'
      resources :contacts
      resource :display
      get 'display/to_authenticate', to: 'displays#to_authenticate', as: 'display_auth'
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
