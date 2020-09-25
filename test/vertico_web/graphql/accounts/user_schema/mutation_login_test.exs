defmodule VerticoWeb.Graphql.Accounts.UserSchema.MutationLoginTest do
  use VerticoWeb.ConnCase, async: true

  @password "12345678"

  describe "when email and password is correct" do
    setup :create_user_with_local_password

    test "should return token", %{conn: conn, user: user} do
      res = post_query(conn, login_user_mutation(), %{email: user.email, password: @password})

      assert %{
        "data" => %{
          "loginUser" => token
        }
      } = res
      assert is_binary(token)
    end

    test "should be insentive for email and return token", %{conn: conn, user: user} do
      res = post_query(conn, login_user_mutation(), %{email: String.upcase(user.email), password: @password})

      assert %{
        "data" => %{
          "loginUser" => token
        }
      } = res
      assert is_binary(token)
    end
  end

  describe "when params is incorrect" do
    setup :create_user_with_local_password

    test "should not return token if password is incorrect", %{conn: conn, user: user} do
      res = post_query(conn, login_user_mutation(), %{email: user.email, password: "incorrect_password"})
      assert error_response("Invalid email or password", "loginUser") == res
    end

    test "should not return token if email is incorrect", %{conn: conn} do
      res = post_query(conn, login_user_mutation(), %{email: "invalid_email@email.com", password: @password})
      assert error_response("Invalid email or password", "loginUser") == res
    end
  end

  defp create_user_with_local_password(_context) do
      user = insert(:user, email: "email@email.com", hashed_password: Argon2.hash_pwd_salt(@password), password: @password)
      %{user: user}
  end

  defp login_user_mutation do
    """
    mutation($email: String!, $password: String!) {
      loginUser(email: $email, password: $password)
    }
    """
  end
end
