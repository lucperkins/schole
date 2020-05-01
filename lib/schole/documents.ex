defmodule Schole.Documents do
  @moduledoc false

  alias Schole.Repo
  alias Schole.Documents.Document
  alias Schole.Projects
  alias Schole.Search

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

  def create(%{document: document, project_id: project_id}) do
    case Projects.get(project_id) do
      nil ->
        {:error, "Project with ID #{project_id} not found"}

      project ->
        changeset =
          %Document{}
          |> Document.create_changeset(document, project)

        case Repo.insert(changeset) do
          {:ok, document} -> index(document)
          {:error, reason} -> {:error, reason}
        end
    end
  end

  def delete(id) do
    case get(id) do
      nil -> {:error, :not_found}
      document -> Repo.delete(document)
    end
  end

  def by_ids(ids) when ids == [], do: []

  def by_ids(ids) do
    Document
    |> Repo.by_ids(ids)
    |> Repo.all()
  end

  def index(%Document{} = document) do
    Search.index(document)
  end
end
