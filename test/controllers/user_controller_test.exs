defmodule WorkoutDemo.UserControllerTest do
  use WorkoutDemo.ConnCase

  alias WorkoutDemo.User
  @valid_registration_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password: "thisisapassword", description: "some content", location: %Geo.Point{}, latitude: 76.5, longitude: 120.5, radius: 1000}
  @valid_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", verified: true, description: "some content", latitude: 76.5, longitude: 120.5, radius: 1000}
  @invalid_attrs %{name: "Coby Benveniste", email: "a fake email", password: "12345", description: "some content", latitude: 900, longitude: 1450, radius: 1000000000000}

  setup %{conn: conn} do
    changeset = User.registration_changeset(%User{}, @valid_registration_attrs)
    user = Repo.insert!(changeset)
    session = WorkoutDemo.Session.create_changeset(%WorkoutDemo.Session{user_id: user.id}, %{}) |> Repo.insert!
    verification_changeset = User.verification_changeset(user, @valid_attrs)
    Repo.update!(verification_changeset)

    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer token=\"#{session.token}\"")
    {:ok, conn: conn, current_user: user }
  end

  # setup %{conn: conn} do
  #   {:ok, conn: put_req_header(conn, "accept", "application/json")}
  # end

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, user_path(conn, :index)
  #   assert json_response(conn, 200)["users"] == []
  # end

  test "shows chosen resource", %{conn: conn} do
    # user = Repo.insert! %User{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5, location: %Geo.Point{}, radius: 1000.0}
    conn = get conn, user_path(conn, :show)
    assert json_response(conn, 200)["user"] == %{"id" => conn.assigns.current_user.id,
      "name" => conn.assigns.current_user.name,
      "email" => conn.assigns.current_user.email,
      "description" => conn.assigns.current_user.description}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = conn |> put_req_header("authorization", "Bearer token=1")
    conn = get conn, user_path(conn, :show)
    assert json_response(conn, 401)
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, user_path(conn, :create), user: @valid_registration_attrs
  #   assert json_response(conn, 201)["user"]["id"]
  #   assert Repo.get_by(User, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, user_path(conn, :create), user: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    # user = Repo.insert! %User{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5, location: %Geo.Point{}, radius: 1000.0}
    conn = put conn, user_path(conn, :update), user: @valid_attrs
    assert json_response(conn, 200)["user"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    # user = Repo.insert! %User{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5, location: %Geo.Point{}, radius: 10000000000000.0}
    conn = put conn, user_path(conn, :update), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    # user = Repo.insert! %User{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 76.5, longitude: 120.5, location: %Geo.Point{}, radius: 1000.0}
    conn = delete conn, user_path(conn, :delete)
    assert response(conn, 204)
    refute Repo.get(User, conn.assigns.current_user.id)
  end
end
