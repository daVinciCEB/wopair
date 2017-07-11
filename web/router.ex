defmodule WorkoutDemo.Router do
  use WorkoutDemo.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WorkoutDemo do
    pipe_through :api
    
    resources "/users", UserController, except: [:new, :edit]
  end
end