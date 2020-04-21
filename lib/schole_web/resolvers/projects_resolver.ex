defmodule ScholeWeb.Resolvers.ProjectsResolver do
  @moduledoc false

  alias Schole.Projects
  alias ScholeWeb.Resolvers.Helpers

  def find(_parent, args, _resolution) do
    projects = Projects.find(args)
    {:ok, projects}
  end

  def create(_parent, args, _resolution) do
    Helpers.wrapped_call(fn -> Projects.create(args) end)
  end

  def delete(_parent, %{id: id}, _resolution) do
    Helpers.wrapped_call(fn -> Projects.delete(id) end)
  end
end
