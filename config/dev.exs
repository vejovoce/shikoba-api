import Mix.Config

require Logger

config :shikoba, Shikoba.Repo,
  database: "shikoba_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :shikoba, ShikobaWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

config :shikoba, ShikobaWeb.BasicAuth,
  username: "admin",
  password: "123123"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :shikoba, Shikoba.Mailer,
  adapter: Bamboo.LocalAdapter

config :shikoba, :environment, :dev

if File.exists? "config/dev.secret.exs" do
  import_config "dev.secret.exs"
else
  File.cp!("config/secret.example.exs", "config/dev.secret.exs")
  Logger.warn("config/dev.secret.exs created. Check your database configuration.")
end
