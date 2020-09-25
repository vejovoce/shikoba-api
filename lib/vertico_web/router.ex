defmodule VerticoWeb.Router do
  use VerticoWeb, :router
  use Plug.ErrorHandler

  import Phoenix.LiveDashboard.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug VerticoWeb.AbsintheContext
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin_only do
    plug VerticoWeb.BasicAuth
  end

  pipeline :homologation do
    VerticoWeb.HomologationOnly
  end

  scope "/" do
    pipe_through [:api, :graphql]

    forward "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: VerticoWeb.GraphQL.Schema,
      interface: :playground

    forward "/graphql",
      Absinthe.Plug,
      schema: VerticoWeb.GraphQL.Schema
  end

  scope "/auth", VerticoWeb do
    pipe_through :browser

    get "/verify-user", AuthController, :verify_user
  end

  scope "/" do
    pipe_through :homologation

    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/" do
    pipe_through [:browser, :admin_only]
    live_dashboard "/status_dashboard", metrics: VerticoWeb.Telemetry
  end

  # Page Controller route should be at the end.
  # If no routes match the backend, send it to the frontend.
  scope "/", VerticoWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
