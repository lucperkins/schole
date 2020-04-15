defmodule Schole.Repo do
  use Ecto.Repo,
    otp_app: :schole,
    adapter: Ecto.Adapters.Postgres
end
