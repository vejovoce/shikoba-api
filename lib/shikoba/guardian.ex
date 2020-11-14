defmodule Shikoba.Guardian do
  @moduledoc """
  Serializes user id into claims and get user from claims
  """
  use Guardian, otp_app: :shikoba

  alias Shikoba.Accounts
  alias Shikoba.Accounts.User
  alias Shikoba.Auth.Tokens

  def subject_for_token(%User{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def resource_from_claims(%{"sub" => id, "hash" => hash}) do
    with  %User{} = user <- Accounts.get_user(id),
          ^hash <- Tokens.generate_verification_hash(user)
    do
      {:ok, user}
    else
      nil -> {:error, "Invalid token"}
      _invalid_hash -> {:error, "Token is no longer valid"}
    end
  end

  def resource_from_claims(%{"sub" => id}) do
    id
    |> Accounts.get_user()
    |> case do
      nil -> {:error, "Invalid token"}
      user -> {:ok, user}
    end
  end
end
