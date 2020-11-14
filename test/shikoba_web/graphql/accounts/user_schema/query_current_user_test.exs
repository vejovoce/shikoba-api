defmodule ShikobaWeb.Graphql.Accounts.UserSchema.QueryCurrentUserTest do
  use ShikobaWeb.ConnCase, async: true

  describe "when token in request is valid" do
    setup [:log_user_in, :set_normal_role_to_current_user]

    test "should return user", %{conn: conn, current_user: user} do
      assert %{
        "data" => %{
          "currentUser" => %{
            "id" => current_user_id
          }
        }
      } = post_query(conn, query_current_user())

      assert current_user_id == user.id
    end
  end

  describe "when token in request is invalid" do
    setup :set_invalid_token

    test "should return current user empty", %{conn: conn} do
      assert %{"data" => %{"currentUser" => nil}} == post_query(conn, query_current_user())
    end
  end

  describe "when not logged in" do
    test "should return current user empty", %{conn: conn} do
      assert %{"data" => %{"currentUser" => nil}} == post_query(conn, query_current_user(), "")
    end
  end

  def set_invalid_token(%{conn: conn}), do: [conn: put_req_token(conn, "invalid.token")]

  defp query_current_user do
    """
    query {
      currentUser {
        id
      }
    }
    """
  end
end
