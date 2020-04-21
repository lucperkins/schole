defmodule ScholeWeb.Resolvers.DocumentsResolver do
  @moduledoc false

  alias Schole.Documents
  alias ScholeWeb.Resolvers.Helpers

  def find(_parent, args, _resolution) do
    documents = Documents.find(args)
    {:ok, documents}
  end

  def get(_parent, %{id: id}, _resolution) do
    document = Documents.get(id)
    {:ok, document}
  end

  def create(_parent, args, _resolution) do
    Helpers.wrapped_call(fn -> Documents.create(args) end)
  end

  def delete(_parans, %{id: id}, _resolution) do
    Helpers.wrapped_call(fn -> Documents.delete(id) end)
  end
end
