defmodule WorkoutDemo.User do
  use WorkoutDemo.Web, :model

  @derive {Poison.Encoder, only: [:name, :email, :description, :latitude, :longitude]}
  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :description, :string
    field :location, Geo.Point
    field :latitude, :float
    field :longitude, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password_hash, :description, :location])
    |> validate_required([:name, :email, :password_hash, :description, :location])
    |> validate_number(:latitude, greater_than_or_equal_to: -90)
    |> validate_number(:latitude, less_than_or_equal_to: 90)
    |> validate_number(:longitude, greater_than_or_equal_to: -180)
    |> validate_number(:longitude, less_than_or_equal_to: 180)
    |> validate_format(:email, ~r/[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,63}/)
    |> unique_constraint(:email)
  end
end
