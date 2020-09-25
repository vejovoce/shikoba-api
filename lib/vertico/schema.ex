defmodule Vertico.Schema do
  @moduledoc """
  Custom Ecto Schema to define all timestamps with type utc_datetime to be compatible with Absinthe.

  All ecto schemas should do `use Vertico.Schema` instead of `use Ecto.Schema`.
  """
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      @timestamps_opts [type: :utc_datetime]
    end
  end
end
