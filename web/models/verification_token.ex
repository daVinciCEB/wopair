defmodule WorkoutDemo.VerificationToken do
  use WorkoutDemo.Web, :model

  schema "verification_tokens" do
    field :token, :string
    belongs_to :user, WorkoutDemo.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id])
    |> put_change(:token, generate_token(params))
    |> validate_required([:token, :user_id])
    |> unique_constraint(:token)
  end

  defp generate_token(nil), do: nil
  defp generate_token(_params) do
    SecureRandom.urlsafe_base64()
  end

  def create_verification_token_for_user(user) do
    changeset = WorkoutDemo.VerificationToken.changeset(%WorkoutDemo.VerificationToken{}, %{user_id: user.id})
    WorkoutDemo.Repo.insert!(changeset)
  end

end
