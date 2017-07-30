defmodule WorkoutDemo.SessionControllerTest do
  use WorkoutDemo.ConnCase

  require Logger

  alias WorkoutDemo.Session
  alias WorkoutDemo.User
  @valid_user_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password: "thisisapassword", description: "some content", location: %Geo.Point{}, latitude: 76.5, longitude: 120.5, radius: 1000}
  @valid_session_attrs %{email: "coby.benveniste@gmail.com", password: "thisisapassword"}

  setup %{conn: conn} do
    changeset = User.registration_changeset(%User{}, @valid_user_attrs)
    Repo.insert!(changeset)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: @valid_session_attrs
    token = json_response(conn, 201)["session"]["token"]
    assert token
    assert Repo.get_by(Session, token: token)
  end

  test "does not create resource and renders errors when password is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: Map.put(@valid_session_attrs, :password, "notright")
    assert json_response(conn, 401)["errors"] != %{}
  end

  test "does not create resource and renders errors when email is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: Map.put(@valid_session_attrs, :email, "not@found.com")
    assert json_response(conn, 401)["errors"] != %{}
  end

end