defmodule WorkoutDemo.VerificationControllerTest do
  use WorkoutDemo.ConnCase

  alias WorkoutDemo.User
  alias WorkoutDemo.VerificationToken

  @valid_registration_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password: "thisisapassword", description: "some content", location: %Geo.Point{}, latitude: 76.5, longitude: 120.5, radius: 1000}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "verifies, updates and renders user when data is valid", %{conn: conn} do
    changeset = User.registration_changeset(%User{}, @valid_registration_attrs)
    user = Repo.insert!(changeset)
    token = VerificationToken.create_verification_token_for_user(user)
    conn = get conn, verification_path(conn, :verify, token.token)
    assert json_response(conn, 200)["session"]
  end

  test "does not verify chosen resource and renders page not found when data is invalid", %{conn: conn} do
    conn = get conn, verification_path(conn, :verify, "123456")
    assert json_response(conn, 401)["error"]
  end
end
