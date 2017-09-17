defmodule CooltWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use CooltWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Coolt.Accounts

  def request(conn, _params) do
    render(conn, "auth.json", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Accounts.find_or_create(auth) do
      {:ok, user} ->
        conn = Coolt.Guardian.Plug.sign_in(conn, user)
        jwt = Coolt.Guardian.Plug.current_token(conn)
        claims = Coolt.Guardian.Plug.current_claims(conn)
        exp = Map.get(claims, "exp")
        conn
          # |> put_resp_header("authorization", "Bearer #{jwt}") # TODO: Why this not working??
          # |> put_resp_header("x-expires", exp)
          |> put_session(:current_user, user)
          |> render "auth.json", user: user, jwt: jwt, exp: exp
     
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end