defmodule ShikobaWeb.GraphQL.Accounts.AccountsResolver do
  @moduledoc """
  Accounts GraphQL resolver.
  """

  alias Shikoba.Accounts
  alias Shikoba.Accounts.User
  alias Shikoba.Auth.Tokens
  alias ShikobaWeb.URL

  alias Crudry.Resolver
  require Resolver

  Resolver.generate_functions Accounts, User

  def create_unverified_user(params, _info) do
    Accounts.create_unverified_user(params, &URL.generate_user_verification_link/1)
  end

  def login_user(%{email: email, password: password}, _info) do
    Accounts.authenticate(email, password)
  end

  def send_verification_email(_params, %{context: %{current_user: user}}) do
    case user.verified do
      true -> {:error, "User already verified"}
      false -> Accounts.send_verification_email(user, &URL.generate_user_verification_link/1)
    end
  end

  def request_reset_password(%{email: email}, _info) do
    case Accounts.get_user_by(email: email) do
      nil ->
        {:error, "Invalid email"}

      %User{} = user ->
        Accounts.send_reset_password_email(user, &URL.generate_reset_password_link/1)
        {:ok, :ok}
    end
  end

  def reset_password(%{token: token, password: password}, _info) do
    with  {:ok, user} <- Accounts.update_password(token, password),
          do: Tokens.generate_login_token(user)
  end

  def get_current_user(_, %{context: %{current_user: user}}), do: {:ok, user}
end
