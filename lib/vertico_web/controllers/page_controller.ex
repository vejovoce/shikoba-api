defmodule VerticoWeb.PageController do
  use VerticoWeb, :controller

  alias Plug.Conn

  def index(%Conn{request_path: path} = conn, params) do
    if Application.get_env(:vertico, :environment) == :dev do
      query =
        params
        |> Map.drop(["path"])
        |> URI.encode_query()
        |> add_question_mark()

      redirect conn, external: "http://localhost:4000#{path}#{query}"
    else
      conn
      |> put_resp_header("content-type", "text/html; charset=utf-8")
      |> Conn.send_file(200, "#{:code.priv_dir(:vertico)}/static/index.html")
    end
  end

  defp add_question_mark(""), do: ""
  defp add_question_mark(query), do: "?" <> query
end
