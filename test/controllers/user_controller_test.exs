defmodule WorkoutDemo.UserControllerTest do
  use WorkoutDemo.ConnCase

  alias WorkoutDemo.User
  @valid_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5}
  @invalid_attrs %{name: "Coby Benveniste", email: "a fake email", password_hash: "thisisapassword", description: "some content", latitude: 900, longitude: 1450}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["users"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5, location: %Geo.Point{}}
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["user"] == %{"id" => user.id,
      "name" => user.name,
      "email" => user.email,
      "description" => user.description}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert json_response(conn, 201)["user"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5, location: %Geo.Point{}}
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 200)["user"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5, location: %Geo.Point{}}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5, location: %Geo.Point{}}
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
