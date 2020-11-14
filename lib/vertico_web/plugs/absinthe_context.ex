defmodule VerticoWeb.AbsintheContext do
  @moduledoc """
  Transforms a token into the current_user and puts it into the Absinthe context.
  """
  @behaviour Plug
  import Plug.Conn

  alias Vertico.Auth.Tokens

  def init(opts), do: opts

  def call(conn, _) do
    user =
      conn
      |> get_req_header("authorization")
      |> List.first()
      |> get_token()
      |> get_current_user()

    ip = get_ip(conn)

    put_private(conn, :absinthe, %{context: %{current_user: user, ip: ip}})
  end

  defp get_token("Bearer " <> token), do: token
  defp get_token(_), do: nil

  defp get_current_user(nil), do: nil

  defp get_current_user(token) do
    case Tokens.get_user_from_token(token, :login) do
      {:ok, current_user} -> current_user
      _ -> nil
    end
  end

  defp get_ip(%{remote_ip: remote_ip}), do: remote_ip |> :inet_parse.ntoa() |> to_string()
end
