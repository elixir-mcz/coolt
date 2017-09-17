defmodule CooltWeb.AuthView do
  use CooltWeb, :view
  alias CooltWeb.AuthView
  import Coolt.Accounts, only: [basic_info: 2]

  def render("auth.json", %{jwt: jwt, user: user}) do
    %{
      user: basic_info(user, :basic),
      groups_user_owner: [], # TODO: create track data to groups
      groups_joined: [],
      jwt: jwt
    }
  end
end
