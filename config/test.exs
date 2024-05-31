import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ukio, Ukio.Repo,
  username: "ukio_code_test",
  password: "ukio_code_test",
  hostname: "db",
  database: "ukio_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ukio, UkioWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RTZ0KBZkwd5+UHaRX6aAbs0D8VzuZlbnSEQirx2ij9kIqan7fYPjut/31b37SNt4",
  server: false

# In test we don't send emails.
config :ukio, Ukio.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
