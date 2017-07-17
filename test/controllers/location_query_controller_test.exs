defmodule WorkoutDemo.LocationQueryControllerTest do
  use WorkoutDemo.ConnCase

  @valid_attrs %{latitude: 76.5, longitude: 120.5, radius: 1000}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "finds all users in a radius in meters when data is valid", %{conn: conn} do
    conn = post conn, location_query_path(conn, :users_within_radius), search: @valid_attrs
    assert json_response(conn, 200)["search_results"]
  end

  test "returns errors when search parameters are invalid", %{conn: conn} do
    conn = post conn, location_query_path(conn, :users_within_radius), search: @invalid_attrs
    assert json_response(conn, 422)["errors"]
  end

end
