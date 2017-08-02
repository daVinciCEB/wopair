defmodule WorkoutDemo.VerificationController do
  use WorkoutDemo.Web, :controller

  alias WorkoutDemo.User
  alias WorkoutDemo.VerificationToken

  def verify(conn, %{"token" => token_provided}) do
    token = Repo.get_by(VerificationToken, token: token_provided) |> Repo.preload(:user)
    # query = from token in VerificationToken, where: token.token == ^token_provided,  select: token
    # token = Repo.one(query)
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
        render(conn, "show.json", user: user)
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
