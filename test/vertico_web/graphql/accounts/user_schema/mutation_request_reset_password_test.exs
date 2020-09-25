defmodule VerticoWeb.Graphql.Accounts.UserSchema.MutationRequestResetPasswordTest do
  use VerticoWeb.ConnCase, async: true
  use Bamboo.Test

  describe "when email is correct" do
    setup [:create_user, :set_normal_role_to_user]

    test "should send an email", %{conn: conn, user: user} do
      assert %{
        "data" => %{
          "requestResetPassword" => "ok"
        }
      } == post_query(conn, mutation_request_reset_password(), %{email: user.email})
      assert_email_delivered_with(subject: "Reset password")
    end
  end

  describe "when email is incorrect" do
    test "should return error", %{conn: conn} do
      expected_error = error_response("Invalid email", "requestResetPassword")
      assert expected_error == post_query(conn, mutation_request_reset_password(), %{email: "invalid email"})
      assert_no_emails_delivered()
    end
  end

  defp mutation_request_reset_password do
    """
    mutation($email: String!) {
      requestResetPassword(email: $email)
    }
    """
  end
end
