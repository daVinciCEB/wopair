defmodule WorkoutDemo.RegistrationControllerTest do
  use WorkoutDemo.ConnCase

  alias WorkoutDemo.User
  @valid_registration_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5, radius: 1000}
  @valid_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", description: "some content", latitude: 76.5, longitude: 120.5, radius: 1000}
  @invalid_attrs %{name: "Coby Benveniste", email: "a fake email", password: "12345", description: "some content", latitude: 900, longitude: 1450, radius: 1000000000000}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @valid_registration_attrs
    assert json_response(conn, 201)["user"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end