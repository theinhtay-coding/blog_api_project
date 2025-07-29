Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # For auth endpoint
  post "/register", to: "auth#register"
  post "/login", to: "auth#login"

  # For article endpoint
  # resources :articles
  #
  # GET /articles → list all
  get "/articles", to: "articles#index"

  # GET /articles/:id → show one
  get "/articles/:id", to: "articles#show"

  # POST /articles → create new
  post "/articles", to: "articles#create"

  # PUT or PATCH /articles/:id → update existing
  put "/articles/:id", to: "articles#update"
  patch "/articles/:id", to: "articles#update"

  # DELETE /articles/:id → delete
  delete "/articles/:id", to: "articles#destroy"

  # For Blog
  #  GET /blog => list all
  get "/blog", to: "blog#index"

  # POST /blog => create new
  post "/blog", to: "blog#create"

  # Defines the root path route ("/")
  # root "posts#index"

  ## Catch-all route for undefined paths
  match "*unmatched", to: "application#route_not_found", via: :all
end
