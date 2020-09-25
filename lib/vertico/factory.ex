defmodule Vertico.Factory do
  @moduledoc """
  ExMachina Factory for generating fake data for tests and seeds.
  """
  use ExMachina.Ecto, repo: Vertico.Repo

  alias Vertico.Accounts.User

  @hashed_password Argon2.hash_pwd_salt("12345678")

  def user_factory do
    %User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      role: :user,
      verified: true,
      hashed_password: @hashed_password
    }
  end
end
