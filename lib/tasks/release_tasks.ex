defmodule Vertico.ReleaseTasks do
  @moduledoc """
  Tasks to facilitate deployment and management in production.
  """

  alias Ecto.Migrator

  @application :vertico

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Migrator.with_repo(repo, &Migrator.run(&1, :up, all: true))
    end
  end

  def seed do
    for repo <- repos() do
      {:ok, _, _} = Migrator.with_repo(repo, &run_seeds_for/1)
    end
  end

  defp repos do
    Application.load(@application)
    Application.fetch_env!(@application, :ecto_repos)
  end

  # Runs the seed script if it exists
  defp run_seeds_for(repo) do
    seed_script = priv_path_for(repo, "seeds.exs")

    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
    end
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"
    Path.join([priv_dir, repo_underscore, filename])
  end
end
