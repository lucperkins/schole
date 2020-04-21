defmodule Schole.ReleaseNotes do
  @moduledoc false

  alias Schole.Repo
  alias Schole.Projects
  alias Schole.ReleaseNotes.ReleaseNote

  def find(args) when args == %{} do
    Repo.all(ReleaseNote)
  end

  def find(args) do
    args
    |> Enum.reduce(ReleaseNote, fn {key, val}, queryable ->
      Repo.find_query(key, queryable, val)
    end)
    |> Repo.all()
  end

  def get(id) do
    Repo.get(Project, id)
  end

  def create(%{new_release_note: %{project_id: project_id}} = attrs) do
    case Projects.get(project_id) do
      nil ->
        {:error, "Project with ID #{project_id} not found"}

      project ->
        %ReleaseNote{}
        |> ReleaseNote.create_changeset(attrs.new_release_note, project)
        |> Repo.insert()
    end
  end

  def delete(id) do
    case get(id) do
      nil -> {:error, :not_found}
      project -> Repo.delete(project)
    end
  end
end
