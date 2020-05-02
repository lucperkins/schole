defmodule Schole.Projects do
  @moduledoc false

  alias Schole.Repo
  alias Schole.Projects.Project

  def find(args) when args == %{} do
    Repo.all(Project)
  end

  def find(args) do
    args
    |> Enum.reduce(Project, fn {key, val}, queryable ->
      Repo.find_query(key, queryable, val)
    end)
    |> Repo.all()
  end

  def get(id) do
    Repo.get(Project, id)
  end

  def create(%{project: new_project}) do
    %Project{}
    |> Project.create_changeset(new_project)
    |> Repo.insert()
  end

  def delete(id) do
    case get(id) do
      nil -> {:error, :not_found}
      project -> Repo.delete(project)
    end
  end
end
