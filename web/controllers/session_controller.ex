defmodule WorkoutDemo.SessionController do
  use WorkoutDemo.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias WorkoutDemo.User
  alias WorkoutDemo.Session

  def create(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, email: user_params["email"])
    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        session_changeset = Session.create_changeset(%Session{}, %{user_id: user.id})
        {:ok, session} = Repo.insert(session_changeset)
        conn
        |> put_status(:created)
        |> render("show.json", session: session)
      user ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
      true ->
        dummy_checkpw()
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
    end
  end

  def delete(conn, _params) do
    with auth_header = get_req_header(conn, "authorization"),
         {:ok, token}   <- parse_token(auth_header),
         {:ok, session} <- find_session_by_token(token),
    do:  delete_session(session)
    send_resp(conn, :no_content, "")
  end

  defp parse_token(["Bearer token=" <> token]) do
    {:ok, String.replace(token, "\"", "")}
  end
  defp parse_token(_non_token_header), do: :error

  defp find_session_by_token(token) do
    case Repo.one(from s in Session, where: s.token == ^token) do
      nil     -> :error
      session -> {:ok, session}
    end
  end

  def delete_session(session) do
    session = Repo.get!(Session, session.id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(session)
  end


end