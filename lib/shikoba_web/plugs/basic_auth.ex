defmodule ShikobaWeb.BasicAuth do
  @moduledoc """
  Module to deal with user authentication
  """

  @behaviour Plug

  import Plug.Conn

  alias Plug.BasicAuth

  def init(opts), do: opts

  def call(conn, opts) do
    credentials = Application.get_env(:shikoba, __MODULE__)
    username = Keyword.fetch!(credentials, :username)
    password = Keyword.fetch!(credentials, :password)

    with  {request_username, request_password} <- BasicAuth.parse_basic_auth(conn),
          valid_username? = Plug.Crypto.secure_compare(username, request_username),
          valid_password? = Plug.Crypto.secure_compare(password, request_password),
          true <- valid_username? and valid_password?
    do
      conn
    else
      _ -> conn |> BasicAuth.request_basic_auth(opts) |> halt()
    end
  end
end
