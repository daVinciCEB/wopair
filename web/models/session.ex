defmodule WorkoutDemo.Session do
  use WorkoutDemo.Web, :model

  @derive {Poison.Encoder, only: [:token]}
  schema "sessions" do
    field :token, :string
    field :ip_address, :string
    belongs_to :user, WorkoutDemo.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :ip_address])
    |> validate_required([:user_id, :ip_address])
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> put_change(:token, SecureRandom.urlsafe_base64())
  end
end
