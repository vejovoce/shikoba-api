import Mix.Config

require Logger

config :vertico, VerticoWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :vertico, Vertico.Repo,
  username: if(System.get_env("CI"), do: System.get_env("POSTGRES_USER"), else: "postgres"),
  password: if(System.get_env("CI"), do: System.get_env("POSTGRES_PASSWORD"), else: "postgres"),
  database: if(System.get_env("CI"), do: System.get_env("POSTGRES_DB"), else: "vertico_test"),
  hostname: if(System.get_env("CI"), do: "postgres", else: "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :vertico, rate_limiter_limit: 9999

config :vertico, Vertico.Mailer,
  adapter: Bamboo.TestAdapter

config :vertico, :environment, :test

if File.exists? "config/test.secret.exs" do
  import_config "test.secret.exs"
else
  if !System.get_env("CI") do
    File.cp!("config/secret.example.exs", "config/test.secret.exs")
    Logger.warn("config/test.secret.exs created. Check your database configuration.")
  end
end
