defmodule Schole.Projects do
  alias Schole.Repo
  alias Schole.Projects.Project

  def all() do
    Repo.all(Project)
  end

  def find(args \\ %{}) do
    Repo.get_by(Project, args)
  end

  def create(attrs \\ %{}) do
    %Project{}
    |> Project.create_changeset(attrs)
    |> Repo.insert()
  end
end
