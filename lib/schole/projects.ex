defmodule Schole.Projects do
  alias Schole.Repo
  alias Schole.Projects.Project

  def list_projects do
    Repo.all(Project)
  end

  def get_project(id) do
    case Repo.get(Project, id) do
      nil -> {:error, :not_found}
      project -> {:ok, project}
    end
  end

  def find_project(args \\ %{}) do
    Repo.get_by(Project, args)
  end

  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.create_changeset(attrs)
    |> Repo.insert()
  end

  def delete_project(id) do
    case get_project(id) do
      {:error, :not_found} -> {:error, :not_found}
      {:ok, project} -> Repo.delete(project)
    end
  end
end
