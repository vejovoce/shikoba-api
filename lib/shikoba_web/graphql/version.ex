defmodule ShikobaWeb.GraphQL.Version do
  @moduledoc false

  use Absinthe.Schema.Notation

  object :version_queries do
    @desc "Gets the application version"
    field :version, :string do
      middleware Rajska.QueryAuthorization, permit: :all
      resolve fn _, _ -> {:ok, Application.spec(:shikoba, :vsn)} end
    end
  end
end
