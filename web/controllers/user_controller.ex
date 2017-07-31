defmodule WorkoutDemo.UserController do
  use WorkoutDemo.Web, :controller

  alias WorkoutDemo.User

  plug WorkoutDemo.Authentication

  # def index(conn, _params) do
  #   users = Repo.all(User)
  #   render(conn, "index.json", users: users)
  # end

  # def create(conn, %{"user" => user_params}) do
  #   location_point = %{"location" => %Geo.Point{coordinates: {user_params["longitude"], user_params["latitude"]}, srid: 4326}}
  #   new_user_params = Map.merge(user_params, location_point)

  #   changeset = User.registration_changeset(%User{}, new_user_params)

  #   case Repo.insert(changeset) do
  #     {:ok, user} ->
  #       conn
  #       |> put_status(:created)
  #       |> put_resp_header("location", user_path(conn, :show, user))
  #       |> render("show.json", user: user)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(WorkoutDemo.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  def show(conn, _params) do
    render(conn, "show.json", user: conn.assigns.current_user)
  end

  def update(conn, %{"user" => user_params}) do
    location_point = %{"location" => %Geo.Point{coordinates: {user_params["longitude"], user_params["latitude"]}, srid: 4326}}
    new_user_params = Map.merge(user_params, location_point)

    user = conn.assigns.current_user
    changeset = User.changeset(user, new_user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WorkoutDemo.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    user = conn.assigns.current_user

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
