defmodule Shikoba.Accounts.AccountsTest do
  use Shikoba.DataCase
  use Bamboo.Test

  alias Shikoba.{
    Accounts,
    Accounts.User,
    Auth.Tokens,
  }

  describe "create_unverified_user/1" do
    test "creates an user and returns a session" do
      link_generator = fn _token -> "www.test.com" end
      params = %{email: "email@email.com", password: "12345678", date_of_birth: Timex.today()}
      assert {:ok, token} = Accounts.create_unverified_user(params, link_generator)

      assert is_binary(token)
      assert_email_delivered_with(subject: "Email confirmation")
    end
  end

  describe "reset_password/2" do
    test "updates the user password" do
      %{hashed_password: old_password} = user = insert(:user, password: "12345678")
      {:ok, token} = Tokens.generate_reset_password_token(user)

      assert {:ok, %User{hashed_password: new_password}} = Accounts.update_password(token, "87654321")
      assert new_password != old_password
    end

    test "only works once for each token" do
      %{hashed_password: old_password} = user = insert(:user, password: "12345678")
      {:ok, token} = Tokens.generate_reset_password_token(user)

      assert {:ok, %User{hashed_password: new_password}} = Accounts.update_password(token, "87654321")
      assert new_password != old_password

      assert {:error, "Token is no longer valid"} = Accounts.update_password(token, "645363623")
    end
  end
end
