defmodule WorkoutDemo.User do
  use WorkoutDemo.Web, :model

  @derive {Poison.Encoder, only: [:name, :email, :description, :latitude, :longitude, :radius]}
  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :verified, :boolean
    field :description, :string
    field :location, Geo.Point
    field :latitude, :float
    field :longitude, :float
    field :radius, :float
    field :password, :string, virtual: true
    has_many :sessions, WorkoutDemo.Session
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :description, :location, :latitude, :longitude, :radius])
    |> validate_required([:name, :email, :description, :location, :latitude, :longitude, :radius])
    |> validate_number(:latitude, greater_than_or_equal_to: -90)
    |> validate_number(:latitude, less_than_or_equal_to: 90)
    |> validate_number(:longitude, greater_than_or_equal_to: -180)
    |> validate_number(:longitude, less_than_or_equal_to: 180)
    |> validate_number(:radius, less_than_or_equal_to: 40000000)
    |> validate_format(:email, ~r/[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,63}/)
    |> unique_constraint(:email)
    |> unique_constraint(:name)
  end



  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> put_change(:verified, false)
    |> validate_length(:password, min: 6)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  def verification_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:verified])
    |> validate_required([:verified])
  end  
end
