defmodule Schole.Documents do
  import Ecto.Query

  alias Schole.Repo
  alias Schole.Documents.Document

  def all() do
    Repo.all(Document)
  end

  def find(args) do
    q =  Enum.reduce(args, Document, fn {key, val}, queryable ->
      where(queryable, ^dynamic([m], field(m, ^key) == ^val))
    end)

    Repo.all(q)
  end

  def create(attrs \\ %{}) do
    %Document{}
    |> Document.create_changeset(attrs)
    |> Repo.insert()
  end
end
