defmodule WorkoutDemo.VerificationControllerTest do
  use WorkoutDemo.ConnCase

  alias WorkoutDemo.User
  @valid_registration_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password: "thisisapassword", description: "some content", location: %Geo.Point{}, latitude: 76.5, longitude: 120.5, radius: 1000}
  @valid_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", verified: true, description: "some content", latitude: 76.5, longitude: 120.5, radius: 1000}
  @invalid_attrs %{name: "Coby Benveniste", email: "a fake email", password: "12345", description: "some content", latitude: 900, longitude: 1450, radius: 1000000000000}

  setup %{conn: conn} do
    changeset = User.registration_changeset(%User{}, @valid_registration_attrs)
    user = Repo.insert!(changeset)
    session = WorkoutDemo.Session.create_changeset(%WorkoutDemo.Session{user_id: user.id}, %{}) |> Repo.insert!

    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer token=\"#{session.token}\"")
    {:ok, conn: conn, current_user: user }
  end

  test "verifies, updates and renders user when data is valid", %{conn: conn} do
    conn = put conn, verification_path(conn, :verify), user: @valid_attrs
    assert json_response(conn, 200)["user"] == %{"id" => conn.assigns.current_user.id,
      "name" => conn.assigns.current_user.name,
      "email" => conn.assigns.current_user.email,
      "verified" => true,
      "description" => conn.assigns.current_user.description}
  end

  test "does not verify chosen resource and renders errors when data is invalid", %{conn: conn} do
    # user = Repo.insert! %User{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5, location: %Geo.Point{}, radius: 10000000000000.0}
    conn = put conn, verification_path(conn, :verify), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
