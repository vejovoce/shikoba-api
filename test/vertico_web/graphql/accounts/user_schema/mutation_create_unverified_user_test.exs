defmodule VerticoWeb.Graphql.Accounts.UserSchema.MutationCreateUnverifiedUserTest do
  use VerticoWeb.ConnCase, async: true

  @password "12345678"

  describe "when params is valid" do
    test "should return token and user", %{conn: conn} do
      assert %{
        "data" => %{
          "createUnverifiedUser" => token
        }
      } = post_query(conn, mutation_create_unverified_user(), %{email: "email@email.com", password: @password})
      assert is_binary(token)
    end
  end

  describe "when params is invalid" do
    test "should return error if email is empty", %{conn: conn} do
      assert error_response("email can't be blank", "createUnverifiedUser") ==
        post_query(conn, mutation_create_unverified_user(), %{email: "", password: @password})
    end

    test "should return error if password is empty", %{conn: conn} do
      assert error_response("password can't be blank", "createUnverifiedUser") ==
        post_query(conn, mutation_create_unverified_user(), %{email: "email@email.com", password: ""})
    end

    test "should return error if email is invalid", %{conn: conn} do
      assert error_response("email has invalid format", "createUnverifiedUser") ==
        post_query(conn, mutation_create_unverified_user(), %{email: "invalid email", password: @password})
    end
  end

  defp mutation_create_unverified_user do
    """
    mutation($email: String!, $password: String!) {
      createUnverifiedUser(email: $email, password: $password)
    }
    """
  end
end
