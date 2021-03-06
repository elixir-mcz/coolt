defmodule CooltWeb.GroupController do
  use CooltWeb, :controller

  alias Coolt.Accounts
  alias Coolt.Accounts.User
  alias Coolt.Accounts.Group
  alias Coolt.Accounts.UserGroup


  action_fallback CooltWeb.FallbackController

  def list_groups_by_radius(conn, _params) do 
    case Coolt.Guardian.resource_from_token(hd get_req_header(conn, "authorization")) do
      {:ok, resource, claims} ->
        user = Accounts.get_user!(resource)
        groups = Accounts.list_groups({_params["lng"], _params["lat"], _params["radius"], user})
        render(conn, "index.json", groups: groups)
    end
  end
  def join_group(conn, _params) do
    case Coolt.Guardian.resource_from_token(hd get_req_header(conn, "authorization")) do
      {:ok, resource, claims} ->
        case {Accounts.get_user!(resource), Accounts.get_group!(_params["group_id"]), _params["status"]} do
          {%User{} = user, %Group{} = group, status} ->
            {:ok, user_group} = Accounts.join_group(%UserGroup{user_id: user.id, group_id: group.id, status: status})
            render(conn, "join.json", user_group: user_group)
        end  
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
    case Coolt.Guardian.resource_from_token(hd get_req_header(conn, "authorization")) do
      {:ok, resource, claims} ->
        group = Accounts.get_group!(id)
        render(conn, "show.json", group: group)
    end
  end
end
