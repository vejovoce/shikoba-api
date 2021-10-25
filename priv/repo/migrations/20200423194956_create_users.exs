defmodule Shikoba.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  alias Shikoba.Accounts.User.RoleEnum

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""
    RoleEnum.create_type()

    create table(:users) do
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :verified, :boolean, default: false, null: false
      add :role, RoleEnum.type()
      add :date_of_birth, :date, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
