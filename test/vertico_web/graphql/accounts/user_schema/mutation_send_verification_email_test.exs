defmodule VerticoWeb.Graphql.Accounts.UserSchema.MutationSendVerificationEmailTest do
  use VerticoWeb.ConnCase, async: true

  describe "when user is not yet verified" do
    setup [:log_user_in, :set_unverified_to_current_user]

    test "should send an email", %{conn: conn, current_user: user} do
      assert %{
        "data" => %{
          "sendVerificationEmail" => %{
            "id" => user.id,
          }
        }
      } == post_query(conn, mutation_send_verification_email())
    end
  end

  describe "when user is already verified" do
    setup [:log_user_in, :set_verified_to_current_user]

    test "should return error", %{conn: conn} do
      expected_error = error_response("User already verified", "sendVerificationEmail")
      assert expected_error == post_query(conn, mutation_send_verification_email())
    end
  end

  defp mutation_send_verification_email do
    """
    mutation {
      sendVerificationEmail {
        id
      }
    }
    """
  end
end
