defmodule ScholeWeb.Resolvers.Projects do
  alias Schole.Projects

  def list_projects(_parent, _args, _resolution) do
    projects = Projects.list_projects

    {:ok, projects}
  end
end
