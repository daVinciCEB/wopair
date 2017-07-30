defmodule WorkoutDemo.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :description, :string, null: false
      add :latitude, :float, null: false
      add :longitude, :float, null: false
      add :radius, :float, null: false
      add :location, :geography, null: false

      timestamps()
    end
    create unique_index(:users, [:name])
    create unique_index(:users, [:email])

  end
end
