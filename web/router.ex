defmodule WorkoutDemo.Router do
  use WorkoutDemo.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WorkoutDemo do
    pipe_through :api

    resources "/register", RegistrationController, only: [:create]
    resources "/users", UserController, except: [:create, :index, :new, :edit]
    resources "/login", SessionController, only: [:create]
    get "/logout", SessionController, :delete

	# JSON REST Routes for Searching
    get "/search", LocationQueryController, :search_users_within_radius
  end
end
