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
        session_changeset = Session.create_changeset(%Session{}, %{user_id: user.id, ip_address: Session.get_user_ip_address(conn)})
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
end
