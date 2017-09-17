defmodule Coolt.Repo.Migrations.CreateGroupsImages do
  use Ecto.Migration

  def change do
    create table(:groups_images) do
      add :url, :string
      add :status, :boolean, default: false, null: false
      add :group_id, references(:groups, on_delete: :nothing)

      timestamps()
    end

    create index(:groups_images, [:group_id])
  end
end
