defmodule ShikobaWeb.Graphql.Accounts.UserSchema.QueryListUsersTest do
  use ShikobaWeb.ConnCase, async: true

  describe "when user is an admin" do
    setup [:log_user_in, :set_admin_role_to_current_user]
    setup [:create_list_of_normal_users]

    test "should return all users", %{conn: conn, current_user: admin, users: [user1, user2]} do
      assert %{
        "data" => %{
          "listUsers" => users
        }
      } = post_query(conn, query_list_users())

      ids = Enum.map(users, & &1["id"])
      assert admin.id in ids
      assert user1.id in ids
      assert user2.id in ids
    end
  end

  describe "when user is normal" do
    setup [:log_user_in, :set_normal_role_to_current_user]

    test "should not authorize", %{conn: conn} do
      expected_error = error_response("unauthorized", "listUsers")
      assert expected_error == post_query(conn, query_list_users())
    end
  end

  def create_list_of_normal_users(_context) do
    %{users: insert_list(2, :user, role: :user)}
  end

  defp query_list_users do
    """
    query {
      listUsers {
        id
      }
    }
    """
  end
end
