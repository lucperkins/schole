defmodule Schole.Documents do
  @moduledoc false

  alias Schole.Repo
  alias Schole.Documents.Document
  alias Schole.Projects

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
        %Document{}
        |> Document.create_changeset(document, project)
        |> Repo.insert()
    end
  end

  def delete(id) do
    case get(id) do
      nil -> {:error, :not_found}
      document -> Repo.delete(document)
    end
  end

  def search(query) do
    provider = Application.get_env(:schole, :search)

    case Application.get_env(:schole, :search) do
      Schole.Search.Postgres -> search(:postgres, query)
      _ -> {:error, "search provider #{provider} not recognized"}
    end
  end

  def search(:postgres, query) do
    Schole.Search.Postgres.search(query)
  end
end
