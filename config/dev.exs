use Mix.Config

config :schole, Schole.Repo,
  username: "postgres",
  password: "postgres",
  database: "schole_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :schole, ScholeWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

config :schole, ScholeWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/schole/(documents).(ex)$",
      ~r"lib/schole/(documents)/.*(ex)$",
      ~r"lib/schole_web/(live|views)/.*(ex)$",
      ~r"lib/schole_web/templates/.*(eex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
