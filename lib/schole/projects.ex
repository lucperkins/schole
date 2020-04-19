defmodule Schole.Projects do
  @moduledoc false

  alias Schole.Repo
  alias Schole.Projects.Project

  def get(id) do
    Repo.get(Project, id)
  end

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

  def create(%{new_project: new_project}) do
    %Project{}
    |> Project.create_changeset(new_project)
    |> Repo.insert()
  end
end
