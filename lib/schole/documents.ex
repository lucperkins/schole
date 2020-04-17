defmodule Schole.Documents do
  import Ecto.Query

  alias Schole.Repo
  alias Schole.Documents.Document
  alias Schole.Projects

  defmacro contains_all(array, item) do
    quote do
      fragment("? @> ?", unquote(array), unquote(item))
    end
  end

  def all() do
    Repo.all(Document)
  end

  # Find Documents based on any combination of title, tag, and/or tags
  def find(args) do
    args
    |> Enum.reduce(Document, fn {key, val}, queryable ->
      find_query(key, queryable, val)
    end)
    |> Repo.all()
  end

  defp find_query(:tags, queryable, tags),
    do: where(queryable, ^dynamic([m], contains_all(m.tags, ^tags)))

  defp find_query(:query, queryable, query),
    do: where(queryable, ^dynamic([m], ilike(m.content, ^"%#{query}%")))

  defp find_query(key, queryable, val),
    do: where(queryable, ^dynamic([m], field(m, ^key) == ^val))

  def create(%{project_id: project_id} = attrs \\ %{}) do
    case Projects.get(project_id) do
      nil ->
        {:error, "Project with ID #{project_id} not found"}

      project ->
        %Document{}
        |> Document.create_changeset(attrs, project)
        |> Repo.insert()
    end
  end
end
