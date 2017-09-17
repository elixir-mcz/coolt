defmodule Coolt.Group.Images do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coolt.Group.Images


  schema "groups_images" do
    field :status, :boolean, default: false
    field :url, :string
    field :group_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Images{} = images, attrs) do
    images
    |> cast(attrs, [:url, :status])
    |> validate_required([:url, :status])
  end
end
