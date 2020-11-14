defmodule Vertico.MixProject do
  use Mix.Project

  def project do
    [
      app: :vertico,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_options: [warnings_as_errors: System.get_env("WARNINGS_AS_ERRORS") == "true"],
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "test.all": :test
      ],
      deps: deps(),
      releases: releases(),
      dialyzer: [
        plt_add_apps: [:ex_unit, :sentry, :mix],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
      ],
    ]
  end

  def application do
    [
      mod: {Vertico.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp releases do
    [
      vertico: [
        include_executables_for: [:unix]
      ]
    ]
  end

  defp deps do
    [
      # Phoenix
      {:phoenix, "~> 1.5.4"},
      {:gettext, "~> 0.18.1"},
      {:jason, "~> 1.2.1"},
      {:plug_cowboy, "~> 2.3"},
      # Dashboard
      {:phoenix_live_dashboard, "~> 0.2.7"},
      # Ecto
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4.5"},
      {:postgrex, "~> 0.15"},
      {:fields, github: "jungsoft/fields", tag: "v0.2.1"},
      {:ecto_enum, "~> 1.4"},
      # Absinthe
      {:absinthe, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4.7"},
      {:dataloader, "~> 1.0.7"},
      # Auth
      {:argon2_elixir, "~> 2.0"},
      {:guardian, "~> 2.1.1"},
      {:rajska, "~> 1.0.1"},
      # Rate limiting
      {:hammer, "~> 6.0"},
      # Testing
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.13.1", only: :test},
      {:ex_machina, "~> 2.4"},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      # Deployment
      {:sentry, "~> 8.0.1"},
      # Utils
      {:crudry, "~> 2.2"},
      {:timex, "~> 3.6.2"},
      {:corsica, "~> 1.1.3"},
      {:remote_ip, "~> 0.2.0"},
      # Telemetry
      {:telemetry_poller, "~> 0.5.1"},
      {:telemetry_metrics, "~> 0.5"},
      # Emails
      {:bamboo, "~> 1.5"},
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.clean": ["ecto.drop", "ecto.create", "ecto.migrate"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "test.all": [
        "credo --strict",
        "dialyzer",
        "coveralls"
      ],
    ]
  end
end
