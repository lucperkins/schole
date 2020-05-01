defmodule Schole.Search.Postgres do
  @moduledoc false

  import Ecto.Query

  alias Schole.Documents.Document
  alias Schole.Repo

  defmodule ILike do
    @moduledoc false

    @behaviour Schole.Search

    def search(query) do
      q =
        from d in Document,
          where: ilike(d.content, ^"%#{query}%")

      Repo.all(q)
    end

    def index(document) do
      # Document is technically already automatically indexed, hence no action
      {:ok, document}
    end
  end
end
