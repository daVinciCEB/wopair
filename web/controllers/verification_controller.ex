defmodule WorkoutDemo.VerificationController do
  use WorkoutDemo.Web, :controller

  alias WorkoutDemo.User

  plug WorkoutDemo.Authentication

  def verify(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user
    changeset = User.verification_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WorkoutDemo.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
