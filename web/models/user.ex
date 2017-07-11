defmodule WorkoutDemo.User do
  use WorkoutDemo.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :description, :string
    field :location, %Geo.Point{}

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password_hash, :description, :location])
    |> validate_required([:name, :email, :password_hash, :description, :location])
    |> validate_format(:email, ~r/[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,63}/)
    |> unique_constraint(:email)
  end
end
