defmodule WorkoutDemo.RegistrationController do
  use WorkoutDemo.Web, :controller

  alias WorkoutDemo.User

  def create(conn, %{"user" => user_params}) do
    location_point = %{"location" => %Geo.Point{coordinates: {user_params["longitude"], user_params["latitude"]}, srid: 4326}}
    new_user_params = Map.merge(user_params, location_point)

    changeset = User.registration_changeset(%User{}, new_user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> assign(:current_user, user)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WorkoutDemo.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
