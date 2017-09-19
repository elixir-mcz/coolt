defmodule Coolt.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :title, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :lat, :float
      add :long, :float

      timestamps()
    end

    create index(:groups, [:user_id])
  end
end
