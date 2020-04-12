defmodule ScholeWeb.Resolvers.Projects do
  alias Schole.Projects

  def list_projects(_parent, _args, _resolution) do
    projects = Projects.list_projects

    {:ok, projects}
  end

  def create_project(_parent, args, _resolution) do
    Projects.create_project(args)
  end
end
