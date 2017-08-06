defmodule WorkoutDemo.SessionController do
  use WorkoutDemo.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias WorkoutDemo.User
  alias WorkoutDemo.Session

  def create(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, email: user_params["email"])
    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        case user.verified do
          true ->
            session_changeset = Session.create_changeset(%Session{ip_address: get_user_ip_address(conn)}, %{user_id: user.id})
            {:ok, session} = Repo.insert(session_changeset)
            conn
            |> put_status(:created)
            |> render("show.json", session: session)
          _otherwise -> verification_error!(conn)
        end
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

  defp get_user_ip_address(conn) do
    # Get the remote IP from the X-Forwarded-For header if present, so this
    # works as expected when behind a load balancer
    remote_ips = Plug.Conn.get_req_header(conn, "x-forwarded-for")
    remote_ip = List.first(remote_ips)

    # If there was nothing in X-Forarded-For, use the remote IP directly
    unless remote_ip do
      # Extract the remote IP from the connection
      remote_ip_as_tuple = conn.remote_ip

      # The remote IP is a tuple like `{127, 0, 0, 1}`, so we need join it into
      # a string for the API. Note that this works for IPv4 - IPv6 support is
      # exercise for the reader!
      remote_ip = Enum.join(Tuple.to_list(remote_ip_as_tuple), ".")
    end
  end

  def delete(conn, _params) do
    case delete_session(conn) do
      {:ok, session} -> logout_session(conn, session)
      _otherwise  -> logout_error!(conn)
    end
  end

  defp delete_session(conn) do
    with auth_header = get_req_header(conn, "authorization"),
         {:ok, token}   <- parse_token(auth_header),
    do:  find_session_by_token(token)
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

  defp logout_session(conn, session) do
    session = Repo.get!(Session, session.id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(session)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:ok, "{ \"logout\": \"Logout Successful\"}")

  end

  defp logout_error!(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:no_content, "")
  end

  defp verification_error!(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:unauthorized, "{ \"error\": \"Verify Your User\"}")
  end
end