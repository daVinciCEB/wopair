defmodule WorkoutDemo.AuthenticationTest do
  use WorkoutDemo.ConnCase

  alias WorkoutDemo.{Authentication, Repo, User, Session}

  @valid_user_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", verified: true, password: "thisisapassword", description: "some content", location: %Geo.Point{}, latitude: 76.5, longitude: 120.5, radius: 1000}
  @opts Authentication.init([])

  def put_auth_token_in_header(conn, token) do
    conn
    |> put_req_header("authorization", "Bearer token=\"#{token}\"")
  end

  test "finds the user by session token", %{conn: conn} do
    changeset = User.registration_changeset(%User{}, @valid_user_attrs)
    user = Repo.insert!(changeset)
    session = Repo.insert!(%Session{token: "123", user_id: user.id})

    conn = conn
    |> put_auth_token_in_header(session.token)
    |> Authentication.call(@opts)

    assert conn.assigns.current_user
  end

  test "invalid session token", %{conn: conn} do
    conn = conn
    |> put_auth_token_in_header("foo")
    |> Authentication.call(@opts)

    assert conn.status == 401
    assert conn.halted
  end

  test "no session token", %{conn: conn} do
    conn = Authentication.call(conn, @opts)
    assert conn.status == 401
    assert conn.halted
  end
end