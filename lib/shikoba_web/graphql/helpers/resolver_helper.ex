defmodule ShikobaWeb.GraphQL.Helpers.ResolverHelper do
  @moduledoc """
  Functions used in the Resolvers.
  """

  def rate_limiter_limit, do: Application.get_env(:shikoba, :rate_limiter_limit)

  def rate_limiter_scale_ms, do: Application.get_env(:shikoba, :rate_limiter_scale_ms)
end
