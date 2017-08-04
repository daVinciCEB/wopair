defmodule WorkoutDemo.Router do
  use WorkoutDemo.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WorkoutDemo do
    pipe_through :api

    # Registration Route
    resources "/register", RegistrationController, only: [:create]

    # User Routes
    get "/me", UserController, :show
    put "/me", UserController, :update
    patch "/me", UserController, :update
    delete "/me", UserController, :delete

    # User Verification Route
    get "/verify/:token", VerificationController, :verify

    # Login and Logout Routes
    resources "/login", SessionController, only: [:create]
    get "/logout", SessionController, :delete

	# Searching Routes
    get "/search", LocationQueryController, :search_users_within_radius
  end
end
