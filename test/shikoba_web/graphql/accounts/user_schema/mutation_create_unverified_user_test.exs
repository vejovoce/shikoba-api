defmodule ShikobaWeb.Graphql.Accounts.UserSchema.MutationCreateUnverifiedUserTest do
  use ShikobaWeb.ConnCase, async: true

  @password "12345678"

  describe "when params is valid" do
    test "should return token and user", %{conn: conn} do
      phones = ["123456789", "+5512344567789"]

      params = %{
        phones: phones,
        email: "email@email.com",
        password: @password,
        birth: "2020-11-14",
      }

      assert %{
        "data" => %{
          "createUnverifiedUser" => token
        }
      } = post_query(conn, mutation_create_unverified_user(), params)
      assert is_binary(token)
    end
  end

  describe "when params is invalid" do
    test "should return error if email is empty", %{conn: conn} do
      params = %{email: "", password: @password, birth: "2020-11-14"}

      assert error_response("email can't be blank", "createUnverifiedUser") ==
        post_query(conn, mutation_create_unverified_user(), params)
    end

    test "should return error if password is empty", %{conn: conn} do
      params = %{email: "email@email.com", password: "", birth: "2020-11-14"}

      assert error_response("password can't be blank", "createUnverifiedUser") ==
        post_query(conn, mutation_create_unverified_user(), params)
    end

    test "should return error if email is invalid", %{conn: conn} do
      params = %{email: "invalid email", password: @password, birth: "2020-11-14"}

      assert error_response("email has invalid format", "createUnverifiedUser") ==
        post_query(conn, mutation_create_unverified_user(), params)
    end
  end

  defp mutation_create_unverified_user do
    """
    mutation($email: String!, $password: String!, $birth: Date!) {
      createUnverifiedUser(email: $email, password: $password, dateOfBirth: $birth)
    }
    """
  end
end
