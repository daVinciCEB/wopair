defmodule WorkoutDemo.VerificationController do
  use WorkoutDemo.Web, :controller

  alias WorkoutDemo.User
  alias WorkoutDemo.VerificationToken
  alias WorkoutDemo.Session

  def verify(conn, %{"token" => token_provided}) do
    token = Repo.get_by(VerificationToken, token: token_provided) |> Repo.preload(:user)
    case token do
      nil -> verification_error!(conn)
      _otherwise -> verify_user(conn, token)
    end
  end

  defp verify_user(conn, token) do
    user_params = %{"user" => token.user}
    verified = %{"verified" => true}
    new_user_params = Map.merge(user_params, verified)
    user = token.user
    changeset = User.verification_changeset(user, new_user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        session_changeset = Session.create_changeset(%Session{}, %{user_id: user.id, ip_address: get_user_ip_address(conn)})
        {:ok, session} = Repo.insert(session_changeset)
        conn
        |> put_status(:ok)
        |> render("show.json", session: session)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WorkoutDemo.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp verification_error!(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:unauthorized, "{ \"error\": \"Verification Not Successful\"}")
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

      # The remote IP is a tuple like `{127, 0, 0, 1}`, so we need join it into a string
      remote_ip = Enum.join(Tuple.to_list(remote_ip_as_tuple), ".")
    end
  end
end
