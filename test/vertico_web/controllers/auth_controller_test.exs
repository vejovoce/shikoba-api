defmodule VerticoWeb.Controllers.AuthControllerTest do
  use VerticoWeb.ConnCase, async: true

  alias Vertico.{
    Accounts,
    Auth.Tokens,
  }
  alias VerticoWeb.URL

  test "going to verify-user page verifies the user's email", %{conn: conn} do
    user = insert(:user, verified: false)
    {:ok, token} = Tokens.generate_verify_email_token(user)
    url = URL.generate_user_verification_link(token)

    conn |> get(url) |> response(302)
    assert Accounts.get_user!(user.id).verified
  end
end
