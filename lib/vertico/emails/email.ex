defmodule Vertico.Email do
  @moduledoc false

  import Bamboo.Email
  alias Bamboo.MandrillHelper

  def verification(to_email, link) do
    to_email
    |> base_email(link)
    |> subject("Email confirmation")
    |> MandrillHelper.put_param("merge_vars", [
      %{
        rcpt: to_email,
        vars: [
          %{"name" => "Link", "content" => link},
        ]
      }
    ])
    |> MandrillHelper.template("verification-template")
  end

  def password_reset_request(to_email, link) do
    to_email
    |> base_email(link)
    |> subject("Reset password")
    |> MandrillHelper.put_param("merge_vars", [
      %{
        rcpt: to_email,
        vars: [
          %{"name" => "Link", "content" => link},
        ]
      }
    ])
    |> MandrillHelper.template("password-reset-request-template")
  end

  defp base_email(to_email, link) do
    new_email()
    |> to(to_email)
    |> from("")
    |> text_body(link)
  end
end
