defmodule Coolt.Accounts.Group do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coolt.Accounts.Group


  schema "groups" do
    field :description, :string
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Group{} = group, attrs) do
    group
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
