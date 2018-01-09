defmodule CooltWeb.Router do
  use CooltWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CooltWeb do
    pipe_through :browser # Use the default browser stack

  end

  scope "/auth", CooltWeb do
    pipe_through [:browser]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/api", CooltWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]

    post "/groups", GroupController, :list_groups_by_radius
    post "/groups/join", GroupController, :join_group
    resources "/groups", GroupController, except: [:new, :edit]
  end
end
