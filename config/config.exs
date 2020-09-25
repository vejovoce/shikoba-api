# General application configuration
import Mix.Config

config :vertico,
  ecto_repos: [Vertico.Repo]

config :vertico, Vertico.Repo,
  start_apps_before_migration: [
    :crypto,
    :ssl,
    :postgrex,
    :ecto_sql,
    :logger,
    :timex,
    :ex_machina
  ]

config :vertico, VerticoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EhLLxR0elCbm5WoIwN9MvU/kAe84PfVj/zSofe0VHR5hGpnh3jMfZ0Mb5rCwekw+",
  render_errors: [view: VerticoWeb.ErrorView, accepts: ~w(json)],
  live_view: [signing_salt: "hq3c/wpXGzicSaU/B2eaK0XaW0Y47vXM"],
  pubsub_server: Vertico.PubSub

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :vertico, Vertico.Guardian,
  issuer: "Vertico",
  secret_key: "VXiouR7TkHSkETWPeY7nxp8EnTu7dBZP5Bph5A70A2uOYkPhVtn5GPfI7WTTdvpQ",
  ttl: { 30, :days }

config :vertico, :cors,
  origins: [
    ~r{^http://localhost:\d+$},
  ]

config :vertico,
  rate_limiter_limit: 5,
  rate_limiter_scale_ms: 30_000

config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 60_000 * 60 * 4,
                                 cleanup_interval_ms: 60_000 * 10]}

import_config "#{Mix.env()}.exs"
