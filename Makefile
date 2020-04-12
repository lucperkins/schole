.PHONY: check clean db-reset deps docs routes run shell test

check:
	@mix check

clean:
	@mix clean

db-reset:
	@mix ecto.reset

deps:
	@mix deps.get

docs:
	@mix do inch, docs
	@open doc/index.html

routes:
	@mix phx.routes

run:
	@mix phx.server

shell:
	@iex -S mix

test:
	@mix test
