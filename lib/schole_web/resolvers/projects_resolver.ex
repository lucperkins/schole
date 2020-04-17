defmodule ScholeWeb.Resolvers.ProjectsResolver do
  @moduledoc false

  alias Schole.Projects
  alias ScholeWeb.Resolvers.Helpers

  def all(_parent, _args, _resolution) do
    projects = Projects.all()

    {:ok, projects}
  end

  def find(_parent, args, _resolution) do
    Helpers.wrapped_call(fn -> Projects.find(args) end, "No project with those attributes found")
  end

  def create(_parent, args, _resolution) do
    Helpers.wrapped_call(fn -> Projects.create(args) end)
  end
end
