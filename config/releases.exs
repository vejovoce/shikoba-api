import Config

stage = System.fetch_env!("STAGE")
homologation? = stage === "homologation"

get_mandatory_env = if homologation?, do: &System.get_env/1, else: &System.fetch_env!/1

config :vertico,
  homologation?: homologation?

config :vertico, Vertico.Repo,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: System.get_env("POOL_SIZE", "10") |> String.to_integer()

config :vertico, VerticoWeb.Endpoint,
  url: [
    scheme: "https",
    host: System.fetch_env!("HOST"),
    port: 443
  ],
  http: [
    :inet6,
    port: System.get_env("PORT", "4000") |> String.to_integer()
  ],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE") # mix phx.gen.secret

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  tags: %{
    stage: stage,
    host: System.fetch_env!("HOST")
  }

config :vertico, VerticoWeb.BasicAuth,
  username: System.get_env("DASHBOARD_USER", "admin"),
  password: System.fetch_env!("DASHBOARD_PASSWORD")

config :vertico, Vertico.Guardian,
  secret_key: System.fetch_env!("GUARDIAN_SECRET_KEY")

config :vertico, :cors,
  origins: "https://" <> System.fetch_env!("HOST")

config :vertico, Vertico.Mailer,
  adapter: (if homologation?, do: Bamboo.LocalAdapter, else: Bamboo.MandrillAdapter),
  api_key: get_mandatory_env.("MAILCHIMP_API_KEY")
