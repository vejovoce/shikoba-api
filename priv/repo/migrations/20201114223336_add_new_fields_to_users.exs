defmodule Shikoba.Repo.Migrations.AddNewFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :phones, {:array, :string}
      add :date_of_birth, :date, null: false
      add :photo, :string
    end
  end
end
