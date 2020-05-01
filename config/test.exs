use Mix.Config

config :schole, Schole.Repo,
  username: "postgres",
  password: "postgres",
  database: "schole_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :schole, ScholeWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
