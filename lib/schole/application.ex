defmodule Schole.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Schole.Repo,
      ScholeWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Schole.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ScholeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
