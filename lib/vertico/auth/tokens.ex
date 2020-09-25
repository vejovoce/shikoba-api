defmodule Vertico.Auth.Tokens do
  @moduledoc """
  Generates and verifies the application's tokens.
  """

  alias Vertico.Accounts.User
  alias Vertico.Guardian

  @token_types ~w(login verify_email reset_password)a

  @spec generate_login_token(User.t) :: {:ok, binary} | {:error, any}
  def generate_login_token(%User{} = user), do: encode_and_sign(user, :login)

  @spec generate_verify_email_token(User.t) :: {:ok, binary} | {:error, any}
  def generate_verify_email_token(%User{} = user), do: encode_and_sign(user, :verify_email)

  @spec generate_reset_password_token(User.t) :: {:ok, binary} | {:error, any}
  def generate_reset_password_token(%User{} = user),
    do: encode_and_sign(user, :reset_password, %{hash: generate_verification_hash(user)}, ttl: {2, :hours})

  @spec encode_and_sign(User.t, atom, map, keyword) :: {:ok, binary} | {:error, any}
  def encode_and_sign(%User{} = user, type, claims \\ %{}, opts \\ []) do
    opts_with_type = Keyword.merge([token_type: type], opts)

    case Guardian.encode_and_sign(user, claims, opts_with_type) do
      {:ok, token, _args} -> {:ok, token}
      {:error, _} = error -> error
    end
  end

  @spec get_user_from_token(binary, :login | :reset_password | :verify_email) :: {:ok, any} | {:error, binary}
  def get_user_from_token(token, type) when type in @token_types do
    case Guardian.resource_from_token(token, %{"typ" => Atom.to_string(type)}) do
      {:ok, user, _claims} -> {:ok, user}
      {:error, error} when is_binary(error) -> {:error, error}
      {:error, _} -> {:error, "Invalid token"}
    end
  end

  @spec generate_verification_hash(User.t) :: binary
  def generate_verification_hash(%User{hashed_password: hashed_password}) do
    String.slice(hashed_password, -10..-1)
  end
end
