defmodule WorkoutDemo.Repo.Migrations.CreateVerificationToken do
  use Ecto.Migration

  def change do
    create table(:verification_tokens) do
      add :token, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:verification_tokens, [:user_id])
    create index(:verification_tokens, [:token])

  end
end
