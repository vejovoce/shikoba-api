{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Shikoba.Repo, :manual)

defmodule TestHelper do
  import Plug.Conn
  import Phoenix.ConnTest
  use ExUnit.Case

  import Shikoba.Factory

  alias Shikoba.Accounts.User
  alias Shikoba.Auth.Tokens
  alias Shikoba.Repo

  @endpoint ShikobaWeb.Endpoint

  def post_query(conn, query, variables \\ %{}, opts \\ %{}) do
    params =
      opts
      |> Map.put(:query, query)
      |> Map.put(:variables, variables)

    conn
    |> post("/graphql", params)
    |> json_response(200)
  end

  def error_response(message, function) do
    %{
      "data" => %{
        function => nil
      },
      "errors" => [
        %{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => message,
          "path" => [function]
        }
      ]
    }
  end

  def authenticate_conn(%User{} = user, conn \\ Phoenix.ConnTest.build_conn()) do
    {:ok, token} = Tokens.generate_login_token(user)

    put_req_token(conn, token)
  end

  def put_req_token(conn, token), do: put_req_header(conn, "authorization", "Bearer #{token}")

  ### Setup

  def log_user_in(_context) do
    user = insert(:user, role: :user)
    conn = authenticate_conn(user)

    [conn: conn, current_user: user]
  end

  def set_normal_role_to_current_user(%{current_user: user}), do: [current_user: update_user(user, role: :user)]

  def set_admin_role_to_current_user(%{current_user: user}), do: [current_user: update_user(user, role: :admin)]

  def set_verified_to_current_user(%{current_user: user}), do: [current_user: update_user(user, verified: true)]

  def set_unverified_to_current_user(%{current_user: user}), do: [current_user: update_user(user, verified: false)]

  def create_user(_context), do: [user: insert(:user, role: :user)]

  def set_normal_role_to_user(%{user: user}), do: [user: update_user(user, role: :user)]

  def set_admin_role_to_user(%{user: user}), do: [user: update_user(user, role: :admin)]

  defp update_user(user, params), do: Repo.update!(Ecto.Changeset.change(user, params))
end
