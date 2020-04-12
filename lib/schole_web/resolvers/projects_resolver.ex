defmodule ScholeWeb.Resolvers.ProjectsResolver do
  alias Ecto.Changeset
  alias Schole.Projects
  alias ScholeWeb.Resolvers.Helpers

  def all(_parent, _args, _resolution) do
    projects = Projects.all

    {:ok, projects}
  end

  def find(_parent, args, _resolution) do
    case Projects.find(args) do
      nil -> {:error, "No project with those attributes found"}
      project -> {:ok, project}
    end
  end

  def create(_parent, args, _resolution) do
    Helpers.wrapped_call(fn -> Projects.create(args) end)
  end
end
