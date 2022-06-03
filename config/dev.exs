use Mix.Config

host = "www.pet-mom.club"
cors_proxy_host = "hubs.local"
assets_host = "hubs.local"
link_host = "hubs.local"

dev_janus_host = host

config :ret, RetWeb.Endpoint,
  url: [scheme: "https", host: host, port: 443],
  static_url: [scheme: "https", host: host, port: 443],
  https: [
    port: 4000,
    certfile: "/home/lonycell/metabooth/.certs/cert.one.pem",
    cacertfile: "/home/lonycell/metabooth/.certs/ca-bundle.pem",
    keyfile: "/home/lonycell/metabooth/.certs/cert.key"
  ],
  cors_proxy_url: [scheme: "https", host: cors_proxy_host, port: 443],
  assets_url: [scheme: "https", host: assets_host, port: 443],
  link_url: [scheme: "https", host: link_host, port: 443],
  imgproxy_url: [scheme: "https", host: assets_host, port: 443],
  debug_errors: true,
  code_reloader: true,
  check_origin: ["//*.pet-mom.club","//*.pet-mom.club:8080","//*.pet-mom.club:8989","//*.pet-mom.club:9090", "//*.reticulum.io"],
  secret_key_base: "txlMOtlaY5x3crvOCko4uV5PM29ul3zGo1oBGNO3cDXx+7GHLKqt0gR9qzgThxb5",
  allowed_origins: "*",
  allow_crawlers: false

config :ret, RetWeb.Endpoint,
  # static_url: [scheme: "https", host: "assets-prod.reticulum.io", port: 443],
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/ret_web/views/.*(ex)$},
      ~r{lib/ret_web/templates/.*(eex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20

env_db_host = "#{System.get_env("DB_HOST")}"

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

config :cors_plug, origin: ["*"]

config :ret,
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
  #FIXME host: "https://#{host}:4000",
  host: "https://#{host}",
  storage_path: "/home/lonycell/metabooth/storage",
  ttl: 60 * 60 * 24

# FIXME
# asset_hosts =
#   "https://localhost https://localhost:4000 https://localhost:8080 https://localhost:8989 https://localhost:9090 https://localhost:3001 " <>
#   "https://#{host} https://#{host}:4000 https://#{host}:8080 https://#{host}:3000 https://#{host}:8989 https://#{host}:9090 https://#{cors_proxy_host}:4000 " <>
#   "https://assets-prod.reticulum.io https://asset-bundles-dev.reticulum.io https://asset-bundles-prod.reticulum.io https://uploads-prod.reticulum.io https://raw.githubusercontent.com https://hubs-proxy.com //*.reticulum.io"

# websocket_hosts =
#   "https://localhost https://localhost:4000 https://localhost:8080 wss://localhost:4000 " <>
#   "https://#{host} https://#{host}:4000 https://#{host}:8080 wss://#{host}:4000 wss://#{host}:8080 wss://#{host}:8989 wss://#{host}:9090 " <>
#   "wss://#{host} wss://#{host}:4000 wss://#{host}:8080 https://#{host}:8080 https://hubs.local:8080 wss://hubs.local:8080"

asset_hosts = "https://#{host} " <>
  "https://#{host}:3001 " <>
  "https://#{host}:4000 " <>
  "https://#{host}:8080 " <>
  "https://#{host}:8989 " <>
  "https://#{host}:9090 " <>
  "https://uploads-prod.reticulum.io"
  "https://assets-prod.reticulum.io"
  "https://#{cors_proxy_host}:4000"

websocket_hosts = "wss://#{host} " <>
  "wss://#{host}:3001 " <>
  "wss://#{host}:4000 " <>
  "wss://#{host}:8080 " <>
  "wss://#{host}:8989 " <>
  "wss://#{host}:9090 "

config :ret, RetWeb.Plugs.AddCSP,
  script_src: asset_hosts,
  font_src: asset_hosts,
  style_src: asset_hosts,
  connect_src: "#{asset_hosts} #{websocket_hosts}",
  img_src: asset_hosts,
  media_src: asset_hosts,
  manifest_src: asset_hosts

#FIXME config :ret, Ret.Mailer, adapter: Bamboo.LocalAdapter
#FIXME config :ret, Ret.Mailer, adapter: Bamboo.GmailAdaptor,
#   sub: "info.matabooth@gmail.com",
#   sandbox: false
#   # json: ( "config/creds-gmail.json" |> File.read! )
config :ret, Ret.Mailer,
  adapter: Bamboo.SMTPAdapter,
  tls: :if_available,
  ssl: :always,
  auth: :always,
  server: "smtp.gmail.com",
  port: "587",
  username: "info.metabooth@gmail.com",
  #password: "!Qaz@Wsx",
  password: "yzmsjaroifsetgks",
  retries: 3


config :goth, json: ( "config/creds-gmail.json" |> File.read! )

config :ret, RetWeb.Email, from: "info.metabooth@gmail.com"

config :ret, Ret.PermsToken, perms_key: ("-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAzWCOsL2rXDXP4hskU3koPgjO19VRz0EXFlIlDROZujM/ms/4
wtEt8yNfCSPUF+95lhaUGTE+jZVTAf8/BQFvoPOSiuyxsPw7vp7XR40Xz45U6C0A
1W4y8k7E5cB1r4v6CyquEL1+YsRi3Qk6I9Ip7dltTB7SbSxSfkDWqJbWckO4Z9vt
pYSzACriWJ5KXNPkrXTs70WrdT5CSN/WJSqXQkoL84euSteqx67XIHqtC3Fe4Nm2
UexwmPln2uS3E/qVGUUi9mvc4zn8sob+ElkaRtqaZzpwddtcg3CvYbTopPT53BXY
ubFTgrUZxsmUuskKp/XAwAqWCxq3a8AIeX2IIQIDAQABAoIBABAVG5djguO5ownF
rlaLCkexUOE95yYfprssu5IGkuct1DE/T++RidOcVXjVwWoOaqsCIZ7HaGqV4uYp
Iro1npQv/q26Uz/UwKjwr1L/DXpHXwa/X21XL84htPF43L5ea7osIW1WKWt6jXNZ
oZ/keTwS5qgrUbcS3XLdiPGyviA8YW7UaXgI1Te5pkRT5t1HbGtZizyHY6ieUz3s
PbaNeoY3mFEOPGOiUBaQ/BUhbqGxEdrz9mhs3OXF/M8xWILDuWWKSrHR/9VxJy8o
e8SkuiwzHCN+DKrKFN9kNUov29xpgmxuSqa4UDGZf0xAuk36QxU0WMucfOfVyG4s
NaCNhkECgYEA5uMA9JBzKjLOxZzLfZQE5K88lqF/ev9GaocaYk6H94grL6fGd9RH
HgMSYmmj3UCV+RX7+zK07z5+KbFFsAJ1drtSTfz/htAvoYTtsC9bTj+3WLQrgKKf
cv9Fk+7TZJgwLFRcuulEhMESPsZuwPndZTXaL3P47tH+jH24kkiCAZ0CgYEA47c+
uWjB28ehQCbdN0aZcMo+ZMQqWF3s4B/58poEimRqW12V15eNXwf/4/KfjZdkf7sD
LNYGWrZSaM26k+7KJhXu1F7AQb/8W4/JC8kHCNbJc0DREuamrchawu+7GnvXBLQu
4ubTBbtdxcN/A7S4g1oxN4J6LrB+7EdjQa0iS1UCgYEAjXgyMagAqK6Q+4xjMwLr
LKQi37j8v4SCxOsbQ3kS3pzUuVJ3zRyIpt8C+MH54audOQ47Y2NiceU8sJcqN/qJ
tsJ4X8jRWO1fAfzNFtMtgviPgw6CSUNbp766Bzai2FRX0BGw7+XWUfFrGIPFgQCY
o1cn5UOOF+cbrUGrQhajchECgYEApyyTJujqUSBomEEv7HGvGifP0IhXEhK6YPv4
sosxxCveDP9Sjzkat2aXDNDFI9y+EivIM/VYKuZo77oBPLN0wqsdb9mzyVFZwhp4
HWfS+0E8GZm/I+IjAbfyMeRvdwztmO1y8m9FApNAT3yrVZwqTXw8X6Uxb+9w7qOm
EcQ6RhUCgYBKKRzdfIJpCjNaZoZlATFplqyb0AIt047W6y46iNQFjUr/vJ9Wk25o
t4XZeWrjWZMkwhpwh50pqyqsv/daUj6gRS3ajkQRKKw1lUDkLBTtCRGfMSNUiaGg
eNgfijPQHjN9c1qEvFL9DSKE7mF/5jDNg2IWoBq8W/+QRABOqB8xUQ==
-----END RSA PRIVATE KEY-----") |> String.replace("\\n", "\n")

config :ret, Ret.OAuthToken, oauth_token_key: ""

config :ret, Ret.Guardian,
  issuer: "ret",
  secret_key: "47iqPEdWcfE7xRnyaxKDLt9OGEtkQG3SycHBEMOuT2qARmoESnhc76IgCUjaQIwX",
  ttl: {12, :weeks}

config :web_push_encryption, :vapid_details,
  subject: "mailto:admin@mozilla.com",
  public_key: "BAb03820kHYuqIvtP6QuCKZRshvv_zp5eDtqkuwCUAxASBZMQbFZXzv8kjYOuLGF16A3k8qYnIN10_4asB-Aw7w",
  # This config value is for local development only.
  private_key: "w76tXh1d3RBdVQ5eINevXRwW6Ow6uRcBa8tBDOXfmxM"

config :sentry,
  environment_name: :dev,
  json_library: Poison,
  included_environments: [],
  tags: %{
    env: "dev"
  }

config :ret, Ret.Habitat, ip: "127.0.0.1", http_port: 9631

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

config :ret, Ret.Account, admin_email: "lonycell@gmail.com"
