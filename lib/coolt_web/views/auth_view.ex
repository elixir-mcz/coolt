defmodule CooltWeb.AuthView do
  use CooltWeb, :view
  alias CooltWeb.AuthView
  import Coolt.Accounts, only: [basic_info: 2]

  def render("auth.json", %{jwt: jwt, user: user, groups: groups}) do
    %{
      user: basic_info(user, :basic),
      groups: groups,
      jwt: jwt
    }
  end
end
