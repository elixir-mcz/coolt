defmodule Coolt.Repo.Migrations.CreateUsersGroups do
  use Ecto.Migration

  def change do
    create table(:users_groups) do
      add :user_id, references(:users, on_delete: :nothing)
      add :group_id, references(:groups, on_delete: :nothing)
      add :status, :boolean, null: false
      timestamps()
    end

    create index(:users_groups, [:user_id])
    create index(:users_groups, [:group_id])
    create unique_index(:users_groups, [:user_id, :group_id])
  end
end
