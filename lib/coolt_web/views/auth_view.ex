defmodule CooltWeb.AuthView do
  use CooltWeb, :view
  alias CooltWeb.AuthView

  def render("auth.json", auth) do
    %{auth: auth}
  end
end
