defmodule ScholeWeb.Resolvers.Projects do
  alias Schole.Projects

  def list_projects(_parent, _args, _resolution) do
    projects = Projects.list_projects

    {:ok, projects}
  end

  def get_project(_parent, args, _resolution) do
    case Projects.find_project(args) do
      nil -> {:error, :not_found}
      project -> {:ok, project}
    end
  end
end
