use Mix.Config

# NOTE: this file contains some security keys/certs that are *not* secrets, and are only used for local development purposes.

#host = "pet-mom.club"
cors_proxy_host = "hubs-proxy.local"
#assets_host = "hubs-assets.local"
#link_host = "hubs-link.local"
host = "www.pet-mom.club"
#cors_proxy_host = "www.pet-mom.club"
assets_host = "www.pet-mom.club"
link_host = "www.pet-mom.club"


# To run reticulum across a LAN for local testing, uncomment and change the line below to the LAN IP
# host = cors_proxy_host = "192.168.1.27"
##lonycell dev_janus_host = "dev-janus.reticulum.io"
dev_janus_host = host

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :ret, RetWeb.Endpoint,
  url: [scheme: "https", host: host, port: 443],
  static_url: [scheme: "https", host: host, port: 443],
  https: [
    port: 4000,
    otp_app: :ret,
    cipher_suite: :strong,
    keyfile: "/home/lonycell/server/.certs/pet-mom.club/key.pem",
    certfile: "/home/lonycell/server/.certs/pet-mom.club/cert.pem"
  ],
  cors_proxy_url: [scheme: "https", host: cors_proxy_host, port: 443],
  assets_url: [scheme: "https", host: assets_host, port: 443],
  link_url: [scheme: "https", host: link_host, port: 443],
  #imgproxy_url: [scheme: "http", host: host, port: 5000],
  imgproxy_url: [scheme: "https", host: host, port: 5001],
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  # This config value is for local development only.
  # secret_key_base: "txlMOtlaY5x3crvOCko4uV5PM29ul3zGo1oBGNO3cDXx+7GHLKqt0gR9qzgThxb5",
  # TODO: mix phx.gen.secret
  secret_key_base: "WJS8eaO7qwfas7LXpsUioC+F3Jypp5GxDa9OSoUEdaVotazU4m98YSV9YO01J8QT",
  allowed_origins: "*",
  allow_crawlers: true

config :logger, level: :info
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

env_db_host = "#{System.get_env("DB_HOST")}"

# Configure your database
config :ret, Ret.Repo,
  username: "postgres",
  password: "postgres",
  database: "ret_dev",
  hostname: if(env_db_host == "", do: "localhost", else: env_db_host),
  template: "template0",
  pool_size: 10

config :ret, Ret.SessionLockRepo,
  username: "postgres",
  password: "postgres",
  database: "ret_dev",
  hostname: if(env_db_host == "", do: "localhost", else: env_db_host),
  template: "template0",
  pool_size: 10

config :ret, RetWeb.Plugs.HeaderAuthorization,
  header_name: "x-ret-admin-access-key",
  header_value: "admin-only"

config :ret, Ret.SlackClient,
  client_id: "",
  client_secret: "",
  bot_token: ""

# Token is our randomly generated auth token to append to Slacks slash command
# As a query param "token"
config :ret, RetWeb.Api.V1.SlackController, token: ""

config :ret, Ret.DiscordClient,
  client_id: "",
  client_secret: "",
  bot_token: ""

config :ret, RetWeb.Api.V1.WhatsNewController, token: ""

config :ret, RetWeb.Plugs.DashboardHeaderAuthorization, dashboard_access_key: ""

# Allow any origin for API access in dev
config :cors_plug, origin: ["*"]

config :ret,
  # This config value is for local development only.
  upload_encryption_key: "a8dedeb57adafa7821027d546f016efef5a501bd",
  bot_access_key: ""

config :ret, Ret.PageOriginWarmer,
  hubs_page_origin: "https://#{host}:8080",
  admin_page_origin: "https://#{host}:8989",
  spoke_page_origin: "https://#{host}:9090",
  insecure_ssl: true

config :ret, Ret.HttpUtils, insecure_ssl: true

config :ret, Ret.MediaResolver,
  giphy_api_key: nil,
  deviantart_client_id: nil,
  deviantart_client_secret: nil,
  imgur_mashape_api_key: nil,
  imgur_client_id: nil,
  youtube_api_key: nil,
  sketchfab_api_key: nil,
  ytdl_host: nil,
  photomnemonic_endpoint: "https://uvnsm9nzhe.execute-api.us-west-1.amazonaws.com/public"

config :ret, Ret.Speelycaptor, speelycaptor_endpoint: "https://1dhaogh2hd.execute-api.us-west-1.amazonaws.com/public"

config :ret, Ret.Storage,
  host: "https://#{host}",
  storage_path: "/home/lonycell/server/hubs/ci/reticulum/_work/reticulum/reticulum/storage",
  ttl: 60 * 60 * 24

asset_hosts =
  "https://localhost:4000 https://localhost:8080 " <>
    "https://#{host} https://#{host}:4000 https://#{host}:8080 https://#{host}:3000 https://#{host}:8989 https://#{host}:9090 https://#{
      cors_proxy_host
    }:4000 " <>
    "https://assets-prod.reticulum.io https://asset-bundles-dev.reticulum.io https://asset-bundles-prod.reticulum.io"

websocket_hosts =
  "https://localhost:4000 https://localhost:8080 wss://localhost:4000 " <>
    "https://#{host}:4000 https://#{host}:8080 wss://#{host}:4000 wss://#{host}:8080 wss://#{host}:8989 wss://#{host}:9090 " <>
    "wss://#{host}:4000 wss://#{host}:8080 https://#{host}:8080 https://localhost:8080 wss://localhost:8080"

config :ret, RetWeb.Plugs.AddCSP,
  script_src: asset_hosts,
  font_src: asset_hosts,
  style_src: asset_hosts,
  connect_src:
    "https://#{host}:8080 https://sentry.prod.mozaws.net #{asset_hosts} #{websocket_hosts} https://www.mozilla.org",
  img_src: asset_hosts,
  media_src: asset_hosts,
  manifest_src: asset_hosts

config :ret, Ret.Mailer, adapter: Bamboo.LocalAdapter

config :ret, RetWeb.Email, from: "info@hubs-mail.com"

#TODO: config :ret, Ret.PermsToken, perms_key: (System.get_env("PERMS_KEY") || "") |> String.replace("\\n", "\n")
config :ret, Ret.PermsToken,
  perms_key:
    "-----BEGIN RSA PRIVATE KEY-----MIIEpAIBAAKCAQEAzWCOsL2rXDXP4hskU3koPgjO19VRz0EXFlIlDROZujM/ms/4wtEt8yNfCSPUF+95lhaUGTE+jZVTAf8/BQFvoPOSiuyxsPw7vp7XR40Xz45U6C0A1W4y8k7E5cB1r4v6CyquEL1+YsRi3Qk6I9Ip7dltTB7SbSxSfkDWqJbWckO4Z9vtpYSzACriWJ5KXNPkrXTs70WrdT5CSN/WJSqXQkoL84euSteqx67XIHqtC3Fe4Nm2UexwmPln2uS3E/qVGUUi9mvc4zn8sob+ElkaRtqaZzpwddtcg3CvYbTopPT53BXYubFTgrUZxsmUuskKp/XAwAqWCxq3a8AIeX2IIQIDAQABAoIBABAVG5djguO5ownFrlaLCkexUOE95yYfprssu5IGkuct1DE/T++RidOcVXjVwWoOaqsCIZ7HaGqV4uYpIro1npQv/q26Uz/UwKjwr1L/DXpHXwa/X21XL84htPF43L5ea7osIW1WKWt6jXNZoZ/keTwS5qgrUbcS3XLdiPGyviA8YW7UaXgI1Te5pkRT5t1HbGtZizyHY6ieUz3sPbaNeoY3mFEOPGOiUBaQ/BUhbqGxEdrz9mhs3OXF/M8xWILDuWWKSrHR/9VxJy8oe8SkuiwzHCN+DKrKFN9kNUov29xpgmxuSqa4UDGZf0xAuk36QxU0WMucfOfVyG4sNaCNhkECgYEA5uMA9JBzKjLOxZzLfZQE5K88lqF/ev9GaocaYk6H94grL6fGd9RHHgMSYmmj3UCV+RX7+zK07z5+KbFFsAJ1drtSTfz/htAvoYTtsC9bTj+3WLQrgKKfcv9Fk+7TZJgwLFRcuulEhMESPsZuwPndZTXaL3P47tH+jH24kkiCAZ0CgYEA47c+uWjB28ehQCbdN0aZcMo+ZMQqWF3s4B/58poEimRqW12V15eNXwf/4/KfjZdkf7sDLNYGWrZSaM26k+7KJhXu1F7AQb/8W4/JC8kHCNbJc0DREuamrchawu+7GnvXBLQu4ubTBbtdxcN/A7S4g1oxN4J6LrB+7EdjQa0iS1UCgYEAjXgyMagAqK6Q+4xjMwLrLKQi37j8v4SCxOsbQ3kS3pzUuVJ3zRyIpt8C+MH54audOQ47Y2NiceU8sJcqN/qJtsJ4X8jRWO1fAfzNFtMtgviPgw6CSUNbp766Bzai2FRX0BGw7+XWUfFrGIPFgQCYo1cn5UOOF+cbrUGrQhajchECgYEApyyTJujqUSBomEEv7HGvGifP0IhXEhK6YPv4sosxxCveDP9Sjzkat2aXDNDFI9y+EivIM/VYKuZo77oBPLN0wqsdb9mzyVFZwhp4HWfS+0E8GZm/I+IjAbfyMeRvdwztmO1y8m9FApNAT3yrVZwqTXw8X6Uxb+9w7qOmEcQ6RhUCgYBKKRzdfIJpCjNaZoZlATFplqyb0AIt047W6y46iNQFjUr/vJ9Wk25ot4XZeWrjWZMkwhpwh50pqyqsv/daUj6gRS3ajkQRKKw1lUDkLBTtCRGfMSNUiaGgeNgfijPQHjN9c1qEvFL9DSKE7mF/5jDNg2IWoBq8W/+QRABOqB8xUQ==-----END RSA PRIVATE KEY-----"

config :ret, Ret.OAuthToken, oauth_token_key: ""

#TODO:
config :ret, Ret.Guardian,
  issuer: "ret",
  # This config value is for local development only.
  secret_key: "47iqPEdWcfE7xRnyaxKDLt9OGEtkQG3SycHBEMOuT2qARmoESnhc76IgCUjaQIwX",
  ttl: {12, :weeks}

#TODO:
config :web_push_encryption, :vapid_details,
  subject: "mailto:admin@mozilla.com",
  public_key: "BAb03820kHYuqIvtP6QuCKZRshvv_zp5eDtqkuwCUAxASBZMQbFZXzv8kjYOuLGF16A3k8qYnIN10_4asB-Aw7w",
  # This config value is for local development only.
  private_key: "w76tXh1d3RBdVQ5eINevXRwW6Ow6uRcBa8tBDOXfmxM"

config :sentry,
  environment_name: :prod,
  json_library: Poison,
  included_environments: [:prod],
  tags: %{
    env: "prod"
  }

config :ret, Ret.Habitat, ip: "127.0.0.1", http_port: 9631

#TODO:
##lonycell -- config :ret, Ret.JanusLoadStatus, default_janus_host: dev_janus_host, janus_port: 443
config :ret, Ret.JanusLoadStatus, default_janus_host: dev_janus_host, janus_port: 4443

config :ret, Ret.RoomAssigner, balancer_weights: [{600, 1}, {300, 50}, {0, 500}]

config :ret, RetWeb.PageController,
  skip_cache: true,
  assets_path: "storage/assets",
  docs_path: "storage/docs"

config :ret, Ret.HttpUtils, insecure_ssl: true

config :ret, Ret.Meta, phx_host: host

config :ret, Ret.Locking,
  lock_timeout_ms: 1000 * 60 * 15,
  session_lock_db: [
    username: "postgres",
    password: "postgres",
    database: "ret_dev",
    hostname: if(env_db_host == "", do: "localhost", else: env_db_host)
  ]

config :ret, Ret.Repo.Migrations.AdminSchemaInit, postgrest_password: "password"
config :ret, Ret.StatsJob, node_stats_enabled: false, node_gauges_enabled: false
config :ret, Ret.Coturn, realm: "ret"
