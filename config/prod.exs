import Mix.Config

config :vertico, VerticoWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :logger, level: :info

config :vertico, :environment, :prod

config :sentry,
  environment_name: :prod,
  included_environments: [:prod],
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  hackney_opts: [pool: :my_pool],
  in_app_module_whitelist: [Vertico, VerticoWeb]

config :vertico, Vertico.Mailer,
  adapter: Bamboo.MandrillAdapter,
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
  ]
