defmodule ScholeWeb.Resolvers.ProjectsResolver do
  @moduledoc false

  alias Schole.Projects
  alias ScholeWeb.Resolvers.Helpers

  def find(args) when args == %{} do
    Repo.all(Document)
  end

  def find(args) do
    args
    |> Enum.reduce(Document, fn {key, val}, queryable ->
      Repo.find_query(key, queryable, val)
    end)
    |> Repo.all()
  end

  def create(_parent, args, _resolution) do
    Helpers.wrapped_call(fn -> Projects.create(args) end)
  end
end
