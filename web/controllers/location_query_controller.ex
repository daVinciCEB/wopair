defmodule WorkoutDemo.LocationQueryController do
  use WorkoutDemo.Web, :controller


  import Geo.PostGIS

  # alias WorkoutDemo.LocationQuery
  alias WorkoutDemo.User

  plug WorkoutDemo.Authentication

  def search_users_within_radius(conn, _params) do
    user_id = conn.assigns.current_user.id
    user_location = conn.assigns.current_user.location
    user_radius = conn.assigns.current_user.radius
    query = from user in User, where: st_distance(user.location, ^user_location)  < ^user_radius, where: user.id != ^user_id,  select: user
    users = Repo.all(query)
    render(conn, "user_search_results.json", users: users)
  end
end
