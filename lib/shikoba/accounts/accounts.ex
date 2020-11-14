defmodule Shikoba.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Dataloader.Ecto, as: DataloaderEcto
  alias Ecto.Multi
  alias Shikoba.Accounts.User
  alias Shikoba.Auth.Tokens
  alias Shikoba.{
    Emails,
    Repo,
  }

  alias Crudry.Context
  require Context

  Context.generate_functions User, except: [:create], update: :update_changeset

  def data, do: DataloaderEcto.new(Repo, query: &query/2)

  def query(queryable, _args), do: queryable

  @doc """
  Creates an user with unverified email and role user, returning a token.
  """
  def create_unverified_user(%{} = attrs, link_generator) do
    Multi.new()
    |> Multi.insert(:user, User.create_unverified_changeset(%User{}, attrs))
    |> Multi.run(:token, fn _, %{user: user} -> Tokens.generate_login_token(user) end)
    |> Multi.run(:send_verification_email, fn _, %{user: user} -> send_verification_email(user, link_generator) end)
    |> Repo.transaction()
    |> case do
      {:ok, %{token: token}} -> {:ok, token}
      {:error, _failed_operation, changes_so_far, _empty_map} -> {:error, changes_so_far}
    end
  end

  @doc """
  Sends a verification email to the user, containing a link with a token that can be used to verify the user's email.
  """
  def send_verification_email(%User{verified: false} = user, link_generator) do
    {:ok, token} = Tokens.generate_verify_email_token(user)
    link = link_generator.(token)

    Emails.send_verification_email(user, link)
    {:ok, user}
  end

  @doc """
  Sends a password reset request email to the user, containing a link with a token that can be used to update the user's password.
  """
  def send_reset_password_email(%User{} = user, link_generator) do
    {:ok, token} = Tokens.generate_reset_password_token(user)
    link = link_generator.(token)

    Emails.send_reset_password_email(user, link)
    {:ok, user}
  end

  @doc """
  Verifies the user email.
  """
  def verify_user(%User{} = user) do
    user
    |> User.verify_changeset(%{verified: true})
    |> Repo.update()
  end

  @doc """
  Updates the user password of the user related to the given token.
  """
  def update_password(token, new_password) do
    with  {:ok, user} <- Tokens.get_user_from_token(token, :reset_password) do
      user
      |> User.password_changeset(%{password: new_password})
      |> Repo.update()
    end
  end

  @doc """
  Given the correct email and password combination, returns a token for the user.
  """
  def authenticate(email, password) do
    user = get_user_by(email: email)

    user
    |> check_password(password)
    |> case do
      true -> Tokens.generate_login_token(user)
      _invalid_user -> {:error, "Invalid email or password"}
    end
  end

  defp check_password(user, password) when is_nil(user) or is_nil(password), do: Argon2.no_user_verify()
  defp check_password(user, password), do: Argon2.verify_pass(password, user.hashed_password)
end
