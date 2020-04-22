defmodule ScholeWeb.Resolvers.ReleaseNotesResolver do
  @moduledoc false

  alias Schole.ReleaseNotes
  alias ScholeWeb.Resolvers.Helpers

  def find(_parent, args, _resolution) do
    projects = ReleaseNotes.find(args)
    {:ok, projects}
  end

  def create(_parent, args, _resolution) do
    Helpers.wrapped_call(fn -> ReleaseNotes.create(args) end)
  end

  def delete(_parent, %{id: id}, _resolution) do
    Helpers.wrapped_call(fn -> ReleaseNotes.delete(id) end)
  end
end
