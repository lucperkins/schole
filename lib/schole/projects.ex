defmodule Schole.Projects do
  alias Schole.Repo
  alias Schole.Projects.Project

  def list_projects do
    Repo.all(Project)
  end

  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.create_changeset(attrs)
    |> Repo.insert()
  end
end
