defmodule Vertico.Repo do
  use Ecto.Repo,
    otp_app: :vertico,
    adapter: Ecto.Adapters.Postgres
end
