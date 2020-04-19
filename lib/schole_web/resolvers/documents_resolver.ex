defmodule ScholeWeb.Resolvers.DocumentsResolver do
  @moduledoc false

  alias Schole.Documents
  alias ScholeWeb.Resolvers.Helpers

  def find(_parent, args, _resolution) do
    documents = Documents.find(args)

    {:ok, documents}
  end

  def create(_parent, args, _resolution) do
    Helpers.wrapped_call(fn -> Documents.create(args) end)
  end
end
