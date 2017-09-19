defmodule Coolt.Accounts.Group do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coolt.Accounts.Group


  schema "groups" do
    field :description, :string
    field :title, :string
    field :user_id, :id
    field :lng, :float
    field :lat, :float

    timestamps()
  end

  @doc false
  def changeset(%Group{} = group, attrs) do
    group
    |> cast(attrs, [:title, :lng, :lat, :description])
    |> validate_required([:title, :lng, :lat, :description])
  end
end
