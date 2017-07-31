defmodule WorkoutDemo.Router do
  use WorkoutDemo.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WorkoutDemo do
    pipe_through :api

    # Register a new user
    resources "/register", RegistrationController, only: [:create]

    # User JSON REST routes
    get "/user", UserController, :show
    put "/user", UserController, :update
    patch "/user", UserController, :update
    delete "/user", UserController, :delete

    # Login and Logout Routes
    resources "/login", SessionController, only: [:create]
    get "/logout", SessionController, :delete

	# JSON REST Routes for Searching
    get "/search", LocationQueryController, :search_users_within_radius
  end
end
