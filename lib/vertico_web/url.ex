
defmodule VerticoWeb.URL do
  @moduledoc """
  Generates URLs for the web application.
  """

  alias VerticoWeb.Endpoint

  def generate_user_verification_link(token) do
    query_string = URI.encode_query(%{token: token})
    "#{Endpoint.url}/auth/verify-user?#{query_string}"
  end

  def generate_reset_password_link(token) do
    query_string = URI.encode_query(%{token: token})
    "#{Endpoint.url}/auth/reset-password?#{query_string}"
  end
end
