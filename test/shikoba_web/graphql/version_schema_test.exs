defmodule ShikobaWeb.Graphql.VersionSchemaTest do
  use ShikobaWeb.ConnCase, async: true

  describe "version" do
    test "returns current application version", %{conn: conn} do
      expected_version = :shikoba |> Application.spec(:vsn) |> to_string()
      assert %{"data" => %{"version" => expected_version}} == post_query(conn, "{ version }")
    end
  end
end
