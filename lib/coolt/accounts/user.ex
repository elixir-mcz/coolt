defmodule Coolt.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coolt.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :avatar, :string
    field :password, :string
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:uuid, :name, :avatar, :email, :password])
    |> validate_required([:uuid, :name, :avatar, :email, :password])
  end
end
