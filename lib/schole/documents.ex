defmodule Schole.Documents do
  import Ecto.Query

  alias Schole.Repo
  alias Schole.Documents.Document
  alias Schole.Projects

  def all() do
    Repo.all(Document)
  end

  def find(args) do
    q =  Enum.reduce(args, Document, fn {key, val}, queryable ->
      cond do
        key == :tags ->
          where(queryable, ^dynamic([m], fragment("? @> ?", m.tags, ^val)))
        key == :tag ->
          where(queryable, ^dynamic([m], ^val in m.tags))
        true ->
          where(queryable, ^dynamic([m], field(m, ^key) == ^val))
      end
    end)

    Repo.all(q)
  end

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
