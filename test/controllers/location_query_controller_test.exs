defmodule WorkoutDemo.LocationQueryControllerTest do
  use WorkoutDemo.ConnCase

  @valid_attrs %{latitude: 76.5, longitude: 120.5, radius: 1000}
  @valid_user_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password: "thisisapassword", description: "some content", location: %Geo.Point{}, latitude: 76.5, longitude: 120.5, radius: 1000}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup %{conn: conn} do
    changeset = WorkoutDemo.User.registration_changeset(%WorkoutDemo.User{}, @valid_user_attrs)
    user = Repo.insert!(changeset)
    session = WorkoutDemo.Session.create_changeset(%WorkoutDemo.Session{user_id: user.id}, %{}) |> Repo.insert!

    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer token=\"#{session.token}\"")
    {:ok, conn: conn, current_user: user }
  end

  test "finds all users in a radius in meters when data is valid using current user", %{conn: conn} do
    conn = get conn, location_query_path(conn, :search_users_within_radius)
    assert json_response(conn, 200)["search_results"]
  end

  # test "finds all users in a radius in meters when data is valid using input parameters", %{conn: conn} do
  #   conn = post conn, location_query_path(conn, :users_within_radius), search: @valid_attrs
  #   assert json_response(conn, 200)["search_results"]
  # end

  test "returns errors when search parameters are invalid", %{conn: conn} do
    conn = post conn, location_query_path(conn, :users_within_radius), search: @invalid_attrs
    assert json_response(conn, 422)["errors"]
  end

end
