defmodule Schole.Documents do
  alias Schole.Repo
  alias Schole.Documents.Document

  def all() do
    Repo.all(Document)
  end

  def find(args) do
    Repo.get_by(Document, args)
  end

  def create(attrs \\ %{}) do
    %Document{}
    |> Document.create_changeset(attrs)
    |> Repo.insert()
  end
end
