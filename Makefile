.PHONY: check clean db-reset deps docs routes run seed shell test

check:
	@mix check

clean:
	@mix clean

db-reset: seed
	@mix ecto.reset

db-setup:
	@mix ecto.setup

deps:
	@mix deps.get

docs:
	@mix do inch, docs
	@open doc/index.html

graphql-sdl:
	@mix absinthe.schema.sdl --schema ScholeWeb.Schema

routes:
	@mix phx.routes

run:
	@mix phx.server

seed:
	@mix run priv/repo/seeds.exs

shell:
	@iex -S mix

test:
	@mix test
