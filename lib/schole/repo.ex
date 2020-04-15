defmodule Schole.Repo do
  use Ecto.Repo,
    otp_app: :schole,
    adapter: Ecto.Adapters.Postgres

  defmacro contains(array, item) do
    quote do
      fragment("? @> ?", ^array, ^item)
    end
  end
end
