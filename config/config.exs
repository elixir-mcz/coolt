# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :coolt,
  ecto_repos: [Coolt.Repo]

# Configures the endpoint
config :coolt, CooltWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4LwP1YPYB6DurKT7NkSnsv3sxYEOgLdyWOhKQSb/P19tXOanCYIbK4bBOfWfV4im",
  render_errors: [view: CooltWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Coolt.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :coolt, Coolt.Guardian,
  issuer: "coolt",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
