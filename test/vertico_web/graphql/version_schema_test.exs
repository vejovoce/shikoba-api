defmodule VerticoWeb.Graphql.VersionSchemaTest do
  use VerticoWeb.ConnCase, async: true

  describe "version" do
    test "returns current application version", %{conn: conn} do
      expected_version = :vertico |> Application.spec(:vsn) |> to_string()
      assert %{"data" => %{"version" => expected_version}} == post_query(conn, "{ version }")
    end
  end
end
