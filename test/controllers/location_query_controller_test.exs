defmodule WorkoutDemo.LocationQueryControllerTest do
  use WorkoutDemo.ConnCase

  @valid_user_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", verified: true, password: "thisisapassword", description: "some content", location: %Geo.Point{}, latitude: 76.5, longitude: 120.5, radius: 1000}

  setup %{conn: conn} do
    changeset = WorkoutDemo.User.registration_changeset(%WorkoutDemo.User{}, @valid_user_attrs)
    user = Repo.insert!(changeset)
    session = WorkoutDemo.Session.create_changeset(%WorkoutDemo.Session{user_id: user.id}, %{}) |> Repo.insert!
    verification_changeset = WorkoutDemo.User.verification_changeset(user, @valid_user_attrs)
    Repo.update!(verification_changeset)

    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer token=\"#{session.token}\"")
    {:ok, conn: conn, current_user: user }
  end

  test "finds all users in a radius in meters when data is valid using current user", %{conn: conn} do
    conn = get conn, location_query_path(conn, :search_users_within_radius)
    assert json_response(conn, 200)["search_results"]
  end
end
