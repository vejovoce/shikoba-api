import Mix.Config

config :shikoba, ShikobaWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :logger, level: :info

config :shikoba, :environment, :prod

config :sentry,
  environment_name: :prod,
  included_environments: [:prod],
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  hackney_opts: [pool: :my_pool],
  in_app_module_whitelist: [Shikoba, ShikobaWeb]

config :shikoba, Shikoba.Mailer,
  adapter: Bamboo.MandrillAdapter,
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
  ]
