defmodule WorkoutDemo.LocationQueryController do
  use WorkoutDemo.Web, :controller


  import Geo.PostGIS

  alias WorkoutDemo.LocationQuery
  alias WorkoutDemo.User

  # Find all Jobs withing a radius in meters
  def users_within_radius(conn, %{"search" => search_params}) do
    changeset = LocationQuery.changeset(%LocationQuery{}, search_params)
    if changeset.valid? do
      point2 = %Geo.Point{coordinates: {search_params["longitude"], search_params["latitude"]}, srid: 4326}
      query = from user in User, where: st_distance(user.location, ^point2)  < ^search_params["radius"],  select: user
      users = Repo.all(query)
      render(conn, "user_search_results.json", users: users)
    else
      conn
        |> put_status(:unprocessable_entity)
        |> render(RecruitmeApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

end
