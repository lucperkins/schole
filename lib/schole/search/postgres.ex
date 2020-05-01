defmodule Schole.Search.Postgres do
  @moduledoc false

  @behaviour Schole.Search

  import Ecto.Query

  alias Schole.Documents.Document
  alias Schole.Repo

  def search(query) do
    q = from d in Document,
      where: ilike(d.content, ^"%#{query}%")

    Repo.all(q)
  end
end
