defmodule Shikoba.Accounts.User do
  @moduledoc """
  User Ecto SQL schema
  """

  use Shikoba.Schema
  import EctoEnum

  alias Ecto.Changeset

  @type t :: %__MODULE__{}

  defenum RoleEnum, :user_role, [:user, :admin]

  schema "users" do
    field :email, Fields.EmailPlaintext
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :role, RoleEnum, default: :user
    field :verified, :boolean, default: false
    field :date_of_birth, :date

    timestamps()
  end

  @unverified_permitted_fields ~w(email password date_of_birth)a
  @unverified_required_fields ~w(email password role verified date_of_birth)a

  @update_permitted_fields ~w(role date_of_birth)a
  @update_required_fields ~w(role date_of_birth)a

  @verify_fields ~w(verified)a
  @password_fields ~w(password)a

  def create_unverified_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @unverified_permitted_fields)
    |> validate_required(@unverified_required_fields)
    |> Fields.EctoValidator.validate_email(:email)
    |> unique_constraint(:email)
    |> base_password_changeset()
  end

  def update_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @update_permitted_fields)
    |> validate_required(@update_required_fields)
  end

  def verify_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @verify_fields)
    |> validate_required(@verify_fields)
  end

  def password_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @password_fields)
    |> validate_required(@password_fields)
    |> base_password_changeset()
  end

  defp base_password_changeset(changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 35)
    |> put_hashed_password()
  end

  defp put_hashed_password(%Changeset{valid?: true, changes: %{password: password}} = current_changeset) do
    put_change(current_changeset, :hashed_password, Argon2.hash_pwd_salt(password))
  end

  defp put_hashed_password(current_changeset), do: current_changeset
end
