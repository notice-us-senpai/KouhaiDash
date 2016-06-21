Rails.application.routes.draw do
# <<<<<<< HEAD
  # resources :task_assignments
  # resources :tasks
  # resources :categories
  # resources :memberships
  # resources :groups
# =======
  # resources :task_assignments
  # resources :tasks
  # resources :categories
  # resources :memberships
  # resources :groups
# >>>>>>> delete-user
  
  mount Judge::Engine => '/judge'

  get 'sessions/new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users

  get 'register', to: 'users#new', as: 'register'
  # user_registration_test.rb dependent on register_path too

  root 'pages#home'

# <<<<<<< HEAD
  # get 'cat_task/:cat_id', to: 'tasks#index', as: 'category_tasks'
# =======
  # get 'cat_task/:cat_id', to: 'tasks#index', as: 'category_tasks'
# >>>>>>> delete-user

  get 'pages/profile'

  get 'calendar', to: 'pages#calendar', as: 'calendar'

  get 'pages/tasks'

  get 'files', to: 'pages#files', as: 'files'

  get 'pages/contacts'
  resources :contacts

  get 'google-calendar', to: 'pages#google_calendar'
  get 'google-drive', to: 'pages#google_drive'
  get 'pages/calendar-callback', to: 'pages#calendar_callback'
  get 'pages/drive-callback', to: 'pages#drive_callback'

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
