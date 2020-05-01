use Mix.Config

config :schole,
  ecto_repos: [Schole.Repo],
  generators: [binary_id: true]

config :schole, ScholeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oiIrKlvDBpqc83q9U4kvuHtaQ43N5ojBU4XCLMGrAyR4N4jjOksodwxZUTt57Rv8",
  render_errors: [view: ScholeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Schole.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "ZTGi9Ji5"]

#config :schole, :search,
#  driver: Schole.Search.Postgres.ILike

config :schole, :search,
  driver: Schole.Search.Algolia,
  application_id: System.get_env("ALGOLIA_APPLICATION_ID"),
  api_key: System.get_env("ALGOLIA_API_KEY")

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
