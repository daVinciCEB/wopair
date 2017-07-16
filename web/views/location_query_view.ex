defmodule WorkoutDemo.LocationQueryView do
  use WorkoutDemo.Web, :view

  def render("user_search_results.json", %{users: users}) do
    %{search_results: render_many(users, WorkoutDemo.UserView, "user.json")}
  end

end
