defmodule ShikobaWeb.Graphql.Accounts.UserSchema.MutationCreateUnverifiedUserTest do
  use ShikobaWeb.ConnCase, async: true

  @password "12345678"

  describe "when params is valid" do
    test "should return token and user", %{conn: conn} do
      assert %{
        "data" => %{
          "createUnverifiedUser" => token
        }
      } = post_query(conn, mutation_create_unverified_user(), %{email: "email@email.com", password: @password, date_of_birth: "2000-01-01"})
      assert is_binary(token)
    end
  end

  describe "when params is invalid" do
    test "should return error if email is empty", %{conn: conn} do
      assert error_response("email can't be blank", "createUnverifiedUser") ==
        post_query(conn, mutation_create_unverified_user(), %{email: "", password: @password, date_of_birth: "2000-01-01"})
    end

    test "should return error if password is empty", %{conn: conn} do
      assert error_response("password can't be blank", "createUnverifiedUser") ==
        post_query(conn, mutation_create_unverified_user(), %{email: "email@email.com", password: "", date_of_birth: "2000-01-01"})
    end

    test "should return error if email is invalid", %{conn: conn} do
      assert error_response("email has invalid format", "createUnverifiedUser") ==
        post_query(conn, mutation_create_unverified_user(), %{email: "invalid email", password: @password, date_of_birth: "2000-01-01"})
    end
  end

  defp mutation_create_unverified_user do
    """
    mutation($email: String!, $password: String!, $date_of_birth: Date!) {
      createUnverifiedUser(email: $email, password: $password, dateOfBirth: $date_of_birth)
    }
    """
  end
end
