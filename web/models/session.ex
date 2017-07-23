defmodule WorkoutDemo.Session do
  use WorkoutDemo.Web, :model

  @derive {Poison.Encoder, only: [:token]}
  schema "sessions" do
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
    |> validate_required([:user_id])
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> put_change(:token, SecureRandom.urlsafe_base64())
  end
end
