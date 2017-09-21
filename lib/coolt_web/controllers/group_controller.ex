defmodule CooltWeb.GroupController do
  use CooltWeb, :controller

  alias Coolt.Accounts
  alias Coolt.Accounts.Group

  action_fallback CooltWeb.FallbackController

  def list_groups_by_radius(conn, _params) do 

    case Coolt.Guardian.resource_from_token(hd get_req_header(conn, "authorization")) do
      {:ok, resource, claims} ->
        user = Accounts.get_user!(resource)
        groups = Accounts.list_groups({_params["lng"], _params["lat"], _params["radius"], user})
        render(conn, "index.json", groups: groups)
    end

  end

  def create(conn, %{"group" => group_params}) do
    with {:ok, %Group{} = group} <- Accounts.create_group(group_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", group_path(conn, :show, group))
      |> render("show.json", group: group)
    end
  end

  def show(conn, %{"id" => id}) do
    group = Accounts.get_group!(id)
    render(conn, "show.json", group: group)
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    group = Accounts.get_group!(id)

    with {:ok, %Group{} = group} <- Accounts.update_group(group, group_params) do
      render(conn, "show.json", group: group)
    end
  end

  def delete(conn, %{"id" => id}) do
    group = Accounts.get_group!(id)
    with {:ok, %Group{}} <- Accounts.delete_group(group) do
      send_resp(conn, :no_content, "")
    end
  end
end
