defmodule VerticoWeb.AuthController do
  use VerticoWeb, :controller

  alias Vertico.Accounts
  alias Vertico.Auth.Tokens

  def verify_user(conn, %{"token" => token}) do
    with {:ok, user} <- Tokens.get_user_from_token(token, :verify_email),
         {:ok, user} <- Accounts.verify_user(user),
         {:ok, token} <- Tokens.generate_login_token(user)
    do
      message = "Your email was successfuly verified. Welcome!"
      redirect(conn, to: Routes.page_path(conn, :index, ["verify-user"], token: token, success_message: message))
    else
      {:error, error} -> redirect(conn, to: Routes.page_path(conn, :index, %{}, error: error))
    end
  end
end
