use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# RetWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.

host = "www.pet-mom.club"
cors_proxy_host = "hubs-proxy.local"
assets_host = "hubs-assets.local"
link_host = "hubs-link.local"
dev_janus_host = host

config :ret, RetWeb.Endpoint,
  https: [
    port: 4000,
    otp_app: :ret,
    keyfile: "/home/lonycell/metabooth/.certs/key.pem",
    certfile: "/home/lonycell/metabooth/.certs/cert.crt"
  ],
  http: [
    port: 4001,
    otp_app: :ret
  ],
  url: [scheme: "https", host: host, port: 443],
  static_url: [scheme: "https", host: host, port: 443],
  cors_proxy_url: [scheme: "https", host: cors_proxy_host, port: 443],
  assets_url: [scheme: "https", host: assets_host, port: 443],
  link_url: [scheme: "https", host: link_host, port: 443],
  imgproxy_url: [scheme: "https", host: host, port: 443],
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  secret_key_base: "txlMOtlaY5x3crvOCko4uV5PM29ul3zGo1oBGNO3cDXx+7GHLKqt0gR9qzgThxb5",
  allowed_origins: "*",
  allow_crawlers: true,
  pubsub: [name: Ret.PubSub, adapter: Phoenix.PubSub.PG2, pool_size: 4],
  server: false,
  root: "."

  config :logger, :console, format: "[$level] $message\n"

config :ret, Ret.Repo,
  username: "postgres",
  password: "postgres",
  database: "ret_production",
  hostname: "localhost",
  template: "template0",
  pool_size: 10

config :ret, Ret.SessionLockRepo,
  username: "postgres",
  password: "postgres",
  database: "ret_production",
  hostname: "localhost",
  template: "template0",
  pool_size: 10

# Finally import the config/prod.secret.exs
# which should be versioned separately.
import_config "prod.secret.exs"

# Filter out media search API params
config :phoenix, :filter_parameters, ["q", "filter", "cursor"]

# Disable prepared queries bc of pgbouncer
config :ret, Ret.Repo, adapter: Ecto.Adapters.Postgres, prepare: :unnamed

config :peerage, via: Ret.PeerageProvider

config :ret, page_auth: [username: "", password: "", realm: "Reticulum"]

config :ret, Ret.Scheduler,
  jobs: [
    # Send stats to StatsD every 5 seconds
    {{:extended, "*/5 * * * *"}, {Ret.StatsJob, :send_statsd_gauges, []}},

    # Flush stats to db every 5 minutes
    {{:cron, "*/5 * * * *"}, {Ret.StatsJob, :save_node_stats, []}},

    # Keep database warm when connected users
    {{:cron, "*/3 * * * *"}, {Ret.DbWarmerJob, :warm_db_if_has_ccu, []}},

    # Rotate TURN secrets if enabled
    {{:cron, "*/5 * * * *"}, {Ret.Coturn, :rotate_secrets, []}},

    # Various maintenence routines
    {{:cron, "0 10 * * *"}, {Ret.Storage, :vacuum, []}},
    {{:cron, "3 10 * * *"}, {Ret.Storage, :demote_inactive_owned_files, []}},
    {{:cron, "4 10 * * *"}, {Ret.LoginToken, :expire_stale, []}},
    {{:cron, "6 10 * * *"}, {Ret.Hub, :vacuum_hosts, []}},
    {{:cron, "7 10 * * *"}, {Ret.CachedFile, :vacuum, []}}
  ]

config :ret, RetWeb.Plugs.HeaderAuthorization, header_name: "x-ret-admin-access-key"

config :ret, Ret.Mailer,
  adapter: Bamboo.SMTPAdapter,
  tls: :always,
  ssl: false,
  retries: 3

config :ret, Ret.Guardian, issuer: "ret", ttl: {12, :weeks}, allowed_drift: 60 * 1000

config :tzdata, :autoupdate, :disabled

config :sentry,
  environment_name: :prod,
  json_library: Poison,
  included_environments: [:prod],
  tags: %{
    env: "prod"
  }

config :ret, Ret.RoomAssigner, balancer_weights: [{600, 1}, {300, 50}, {0, 500}]

config :ret, Ret.Locking,
  lock_timeout_ms: 1000 * 60 * 15,
  session_lock_db: [
    username: "postgres",
    password: "postgres",
    database: "ret_production",
    hostname: "localhost"
  ]

config :ret, Ret.JanusLoadStatus, janus_port: 4443

# Default stats job to off so for polycosm hosts the database can go idle
config :ret, Ret.StatsJob, node_stats_enabled: false, node_gauges_enabled: false

# Default repo check and page check to off so for polycosm hosts database + s3 hits can go idle
config :ret, RetWeb.HealthController, check_repo: false

#
config :ret, Ret.Storage,
  #host: "https://#{host}:4000",
  storage_path: "storage/dev",
  ttl: 60 * 60 * 24

#
config :ret, Ret.JanusLoadStatus, default_janus_host: dev_janus_host, janus_port: 4443
