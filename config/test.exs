use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :libra, Libra.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :libra, Libra.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "libra_test",
  hostname: System.get_env("PG_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :libra, :sql_sandbox, true

config :wallaby, :js_logger, nil
