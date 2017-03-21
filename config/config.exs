# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :libra,
  ecto_repos: [Libra.Repo]

# Configures the endpoint
config :libra, Libra.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6YDgW55koaA24IM33OyHFweAC3fcgN7gKXP09kuk8QFAxA7rZLpcMQjlY9RyC3k6",
  render_errors: [view: Libra.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Libra.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  binary_id: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
