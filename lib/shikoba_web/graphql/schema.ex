defmodule ShikobaWeb.GraphQL.Schema do
  @moduledoc """
  Defines the Absinthe GraphQL schema.
  """
  use Absinthe.Schema
  alias Absinthe.{
    Middleware,
    Plugin,
  }
  alias Absinthe.Type.Object
  alias Crudry.Middlewares.TranslateErrors
  alias Shikoba.Accounts
  alias Shikoba.Auth.Authorization
  alias ShikobaWeb.GraphQL.Middlewares.SafeResolver

  import_types Absinthe.Plug.Types
  import_types Absinthe.Type.Custom

  import_types ShikobaWeb.GraphQL.{
    Accounts.UserSchema,
    Version,
  }

  # Default pagination params
  @desc "Sorting order"
  enum :sorting_order do
    value :asc, description: "Ascending order"
    value :desc, description: "Descending order"
  end

  input_object :pagination_params do
    field :limit, :integer
    field :offset, :integer
    field :sorting_order, :sorting_order
    field :order_by, :string
  end

  query do
    import_fields :user_queries
    import_fields :version_queries
  end

  mutation do
    import_fields :user_mutations
  end

  def context(ctx) do
    loader = Dataloader.add_source(Dataloader.new(), Accounts, Accounts.data())

    ctx
    |> Map.put(:loader, loader)
    |> Map.put(:authorization, Authorization)
  end

  def plugins do
    [Middleware.Dataloader] ++ Plugin.defaults()
  end

  def middleware(middleware, field, object) do
    middleware
    |> add_safe_resolver()
    |> add_authorization(field, object)
    |> add_translate_errors()
  end

  defp add_safe_resolver(middlewares) do
    Enum.map(middlewares, fn
      {{Resolution, :call}, resolver_fnc} -> safe_resolver_middleware(resolver_fnc)
      {Resolution, resolver_fnc} -> safe_resolver_middleware(resolver_fnc)
      middleware -> middleware
    end)
  end

  defp safe_resolver_middleware(resolver_fnc), do: {{Resolution, :call}, SafeResolver.resolve_safely(resolver_fnc)}

  defp add_translate_errors(middleware), do: middleware ++ [TranslateErrors]

  defp add_authorization(middleware, field, %Object{identifier: identifier}) when identifier in [:query, :mutation] do
    middleware
    |> Rajska.add_query_authorization(field, Authorization)
    |> Rajska.add_object_authorization()
  end

  defp add_authorization(middleware, _field, _object) do
    middleware
  end
end
