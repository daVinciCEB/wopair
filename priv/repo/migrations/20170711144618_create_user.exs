defmodule WorkoutDemo.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :verified, :boolean, default: false, null: false
      add :description, :string
      add :latitude, :float
      add :longitude, :float
      add :radius, :float, default: 1000, null: false
      add :location, :geography

      timestamps()
    end
    create unique_index(:users, [:name])
    create unique_index(:users, [:email])

  end
end
