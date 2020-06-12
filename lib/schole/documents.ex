defmodule Schole.Documents do
  @moduledoc false

  alias Schole.Repo
  alias Schole.Documents.Document
  alias Schole.Search

  @type all() :: [Document]
  def all() do
    find(%{})
  end

  def find(args) when args == %{} do
    Repo.all(Document)
  end

  def find(args) do
    args
    |> Enum.reduce(Document, fn {key, val}, queryable ->
      Repo.find_query(key, queryable, val)
    end)
    |> Repo.all()
  end

  def get(id) do
    Repo.get(Document, id)
  end

  def create(%{document: document}) do
    document
    |> Document.create_changeset()
    |> Repo.insert()
    |> case do
      {:ok, document} -> index(document)
      {:error, reason} -> {:error, reason}
    end
  end

  @spec delete(Ecto.UUID) :: {:ok, Document} | {:error, term}
  def delete(id) do
    case get(id) do
      nil -> {:error, :not_found}
      document -> Repo.delete(document)
    end
  end

  @spec by_ids([String]) :: [Document]
  def by_ids(ids) when ids == [], do: []

  def by_ids(ids) do
    Document
    |> Repo.by_ids(ids)
    |> Repo.all()
  end

  @spec search(String) :: [Document]
  def search(query) do
    Search.search(query)
  end

  @spec index(Document) :: {:ok, Document} | {:error, term}
  def index(document) do
    Search.index(document)
  end
end
