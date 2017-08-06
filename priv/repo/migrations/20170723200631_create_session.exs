defmodule WorkoutDemo.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :token, :string, null: false
      add :ip_address, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:sessions, [:user_id])
    create index(:sessions, [:token])

  end
end
