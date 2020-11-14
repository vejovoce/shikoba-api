defmodule ShikobaWeb.HomologationOnly do
  @moduledoc """
  Allows calls only in development or homologation.
  """
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    dev_or_homologation? =
      :shikoba
      |> Application.get_env(:environment)
      |> Kernel.==(:dev)
      |> Kernel.||(Application.get_env(:shikoba, :homologation?))

    if dev_or_homologation? do
      conn
    else
      conn
      |> send_resp(404, "Not found")
      |> halt()
    end
  end
end
