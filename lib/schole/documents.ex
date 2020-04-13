defmodule Schole.Documents do
  import Ecto.Query
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Schole.Repo
  alias Schole.Documents.Document
  alias Schole.Projects

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
    changeset = %Document{} |> Document.create_changeset(attrs)

    if changeset.valid? do
      project_id = get_change(changeset, :project_id)

      case Projects.get(project_id) do
        nil ->
          {:error, "Project with ID #{project_id} not found"}
        project ->
          changeset = %Document{} |> Document.create_changeset(attrs)

          if changeset.valid? do
            changeset
            |> Changeset.put_assoc(:project, project)
            |> Repo.insert()
          else
            {:error, changeset}
          end
      end
    else
      {:error, changeset}
    end
  end
end
