defmodule Coolt.Accounts.UserGroup do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coolt.Accounts.UserGroup


  schema "users_groups" do
    field :user_id, :id
    field :group_id, :id
    field :status, :boolean

    timestamps()
  end

  @doc false
  def changeset(%UserGroup{} = user_group, attrs) do
    user_group
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
