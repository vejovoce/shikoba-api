defmodule VerticoWeb.GraphQL.Middlewares.SafeResolver do
  @moduledoc """
  Module that allows the server to never fail silently, but to always return an error.
  """

  require Logger

  def resolve_safely(fun) when is_function(fun) do
    execute_safely(fun, :erlang.fun_info(fun)[:arity])
  end

  defp execute_safely(fun, 2) do
    fn args, info ->
      try do
        fun.(args, info)
      rescue
        exception -> handle_exception(exception, __STACKTRACE__, info)
      end
    end
  end

  defp execute_safely(fun, 3) do
    fn record, args, info ->
      try do
        fun.(record, args, info)
      rescue
        exception -> handle_exception(exception, __STACKTRACE__, info)
      end
    end
  end

  defp handle_exception(exception, stacktrace, info) do
    Sentry.capture_exception(exception, stacktrace: stacktrace, extra: %{
      query: info.definition.name,
      arguments: info.arguments,
      source_struct: get_source_struct(info.source)
    })

    :error
    |> Exception.format(exception, stacktrace)
    |> Logger.error()

    {:error, "Internal server error"}
  end

  defp get_source_struct(%struct{}), do: struct
  defp get_source_struct(_else), do: nil
end
