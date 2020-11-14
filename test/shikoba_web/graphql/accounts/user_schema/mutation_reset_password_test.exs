defmodule ShikobaWeb.Graphql.Accounts.UserSchema.MutationResetPasswordTest do
  use ShikobaWeb.ConnCase, async: true

  alias Shikoba.Auth.Tokens

  describe "when token is valid" do
    setup :generate_reset_password_token

    test "should update user password", %{conn: conn, token: token} do
      assert %{
        "data" => %{
          "resetPassword" => token
        }
      } = post_query(conn, mutation_reset_password(), %{token: token, password: "123123123"})
      assert is_binary(token)
    end
  end

  describe "when token is incorrect" do
    test "should return error", %{conn: conn} do
      expected_error = error_response("Invalid token", "resetPassword")
      assert expected_error ==
        post_query(conn, mutation_reset_password(), %{token: "invalid token", password: "123123123"})
    end
  end

  describe "when password is invalid" do
    setup :generate_reset_password_token

    test "should return error", %{conn: conn, token: token} do
      expected_error = error_response("password can't be blank", "resetPassword")
      assert expected_error == post_query(conn, mutation_reset_password(), %{token: token, password: ""})
    end
  end

  defp generate_reset_password_token(_context) do
    user = insert(:user)
    {:ok, token} = Tokens.generate_reset_password_token(user)

    %{token: token}
  end

  defp mutation_reset_password do
    """
    mutation($token: String!, $password: String!) {
      resetPassword(token: $token, password: $password)
    }
    """
  end
end
