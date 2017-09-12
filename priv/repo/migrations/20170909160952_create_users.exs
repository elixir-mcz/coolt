defmodule Coolt.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uuid, :uuid
      add :name, :string
      add :avatar, :string
      add :email, :string
      add :password, :string

      timestamps()
    end

  end
end
