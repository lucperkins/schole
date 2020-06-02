defmodule Schole.Repo do
  import Ecto.Query

  use Ecto.Repo,
    otp_app: :schole,
    adapter: Ecto.Adapters.Postgres

  defmacro contains_all(array, item) do
    quote do
      fragment("? @> ?", unquote(array), unquote(item))
    end
  end

  def find_query(:tags, queryable, tags),
    do: where(queryable, ^dynamic([m], contains_all(m.tags, ^tags)))

  def find_query(:query, queryable, query),
    do: where(queryable, ^dynamic([m], ilike(m.content, ^"%#{query}%")))

  def find_query(:description, queryable, description),
    do: where(queryable, ^dynamic([m], ilike(m.description, ^"#{description}%") ))

  def find_query(key, queryable, val),
    do: where(queryable, ^dynamic([m], field(m, ^key) == ^val))

  def by_ids(query, ids),
    do:
      from(q in query, where: q.id in ^ids, order_by: fragment("array_position(?, ?)", ^ids, q.id))
end
