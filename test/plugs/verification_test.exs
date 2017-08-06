defmodule WorkoutDemo.VerificationTest do
  use WorkoutDemo.ConnCase

  alias WorkoutDemo.{Authentication, Verification, Repo, User, Session}

  @valid_user_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", verified: true, password: "thisisapassword", description: "some content", location: %Geo.Point{}, latitude: 76.5, longitude: 120.5, radius: 1000}
  @opts Verification.init([])

  def put_auth_token_in_header(conn, token) do
    conn
    |> put_req_header("authorization", "Bearer token=\"#{token}\"")
  end

  test "user is verified", %{conn: conn} do
    changeset = User.registration_changeset(%User{}, @valid_user_attrs)
    user = Repo.insert!(changeset)
    session = Session.create_changeset(%Session{user_id: user.id, ip_address: "127.0.0.1"}, %{}) |> Repo.insert!
    verification_changeset = User.verification_changeset(user, @valid_user_attrs)
    Repo.update!(verification_changeset)

    conn = conn
    |> put_auth_token_in_header(session.token)
    |> Authentication.call(Authentication.init([]))
    |> Verification.call(@opts)
    assert conn.assigns.current_user.verified == true;
  end

  test "user is not verified", %{conn: conn} do
    changeset = User.registration_changeset(%User{}, @valid_user_attrs)
    user = Repo.insert!(changeset)
    session = Session.create_changeset(%Session{user_id: user.id, ip_address: "127.0.0.1"}, %{}) |> Repo.insert!

    conn = conn
    |> put_auth_token_in_header(session.token)
    |> Authentication.call(Authentication.init([]))
    |> Verification.call(@opts)

    assert conn.status == 401
    assert conn.halted
  end
end