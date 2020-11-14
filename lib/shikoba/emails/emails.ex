defmodule Shikoba.Emails do
  @moduledoc """
  Public API for the application's emails.
  """

  alias Shikoba.Accounts.User
  alias Shikoba.{
    Email,
    Mailer
  }

  def send_verification_email(%User{email: email}, link) do
    email
    |> Email.verification(link)
    |> Mailer.deliver_later()
    {:ok, email}
  end

  def send_reset_password_email(%User{email: email}, link) do
    email
    |> Email.password_reset_request(link)
    |> Mailer.deliver_later()
    {:ok, email}
  end
end
