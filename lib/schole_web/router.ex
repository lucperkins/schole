defmodule ScholeWeb.Router do
  use ScholeWeb, :router

  alias ScholeWeb.Schema

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug.GraphiQL,
      schema: Schema,
      interface: :playground

    forward "/", Absinthe.Plug, schema: Schema
  end
end
