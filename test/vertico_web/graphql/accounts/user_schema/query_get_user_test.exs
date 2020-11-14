defmodule VerticoWeb.Graphql.Accounts.UserSchema.QueryGetUserTest do
  use VerticoWeb.ConnCase, async: true

  setup [:create_user, :set_normal_role_to_user]

  describe "when user is an admin" do
    setup [:log_user_in, :set_admin_role_to_current_user]

    test "should get any user", %{conn: conn, user: %{id: another_user_id}} do
      assert %{
        "data" => %{
          "getUser" => %{"id" => user_id}
        }
      } = post_query(conn, query_get_user(), %{id: another_user_id})

      assert user_id == another_user_id
    end
  end

  describe "when user is normal" do
    setup [:log_user_in, :set_normal_role_to_current_user]

    test "should get your own user", %{conn: conn, current_user: %{id: current_user_id}} do
      assert %{
        "data" => %{
          "getUser" => %{"id" => user_id}
        }
      } = post_query(conn, query_get_user(), %{id: current_user_id})

      assert user_id == current_user_id
    end

    test "should not get another user", %{conn: conn, user: %{id: another_user_id}} do
      assert error_response("Not authorized to access this user", "getUser") ==
        post_query(conn, query_get_user(), %{id: another_user_id})
    end
  end

  describe "when not logged in" do
    setup [:create_user, :set_normal_role_to_user]

    test "should not get the user", %{conn: conn, user: user} do
      assert error_response("unauthorized", "getUser") == post_query(conn, query_get_user(), %{id: user.id})
    end
  end

  defp query_get_user do
    """
    query($id: Int!) {
      getUser(id: $id) {
        id
      }
    }
    """
  end
end
