defmodule ScholeWeb.Resolvers.DocumentsResolver do
  alias Schole.Documents
  alias ScholeWeb.Resolvers.Helpers

  def all(_parent, _args, _resolution) do
    documents = Documents.all()

    {:ok, documents}
  end

  def find(_parent, args, _resolution) do
    documents = Documents.find(args)

    {:ok, documents}
  end

  def create(_parent, args, _resolution) do
    IO.inspect(args)

    Helpers.wrapped_call(fn -> Documents.create(args) end)
  end
end
