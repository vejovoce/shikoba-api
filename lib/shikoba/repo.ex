defmodule Shikoba.Repo do
  use Ecto.Repo,
    otp_app: :shikoba,
    adapter: Ecto.Adapters.Postgres
end
