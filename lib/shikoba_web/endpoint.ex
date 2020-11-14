defmodule ShikobaWeb.Endpoint do
  use Sentry.PlugCapture
  use Phoenix.Endpoint, otp_app: :shikoba

  alias ShikobaWeb.{
    Router,
    UserSocket,
  }

  plug Corsica,
    origins: Application.get_env(:shikoba, :cors)[:origins],
    allow_methods: :all,
    allow_headers: :all,
    allow_credentials: true

  socket "/socket", UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :shikoba,
    gzip: true,
    only: ~w(
      static
      images
      robots.txt
      index.html
      manifest.json
      cache_manifest.json
      asset-manifest.json
      favicon.ico
      favicon.png
      apple-touch-icon.png
      service-worker.js
    ),
    only_matching: ~w(
      precache-manifest
      workbox
    )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Sentry.PlugContext
  plug RemoteIp

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_shikoba_key",
    signing_salt: "vX+7ZV3I"

  plug Router
end
