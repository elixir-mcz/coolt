defmodule Coolt.Accounts.GroupImage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coolt.Accounts.GroupImage


  schema "groups_images" do
    field :status, :boolean, default: false
    field :url, :string
    field :group_id, :id
    field :default_image, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(%GroupImage{} = group_images, attrs) do
    group_images
    |> cast(attrs, [:url, :status])
    |> validate_required([:url, :status])
  end
end
