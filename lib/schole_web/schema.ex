defmodule ScholeWeb.Schema do
  @moduledoc false

  use Absinthe.Schema
  import_types(ScholeWeb.Schema.ContentTypes)

  alias ScholeWeb.Resolvers.DocumentsResolver

  query do
    @desc "Find documents via some combination of title, tags, or text query string"
    field :find_documents, list_of(:document) do
      arg(:title, :string)
      arg(:description, :string)
      arg(:tags, list_of(:string))

      resolve(&DocumentsResolver.find/3)
    end

    field :search_documents, list_of(:document) do
      arg(:query, non_null(:string))

      resolve(&DocumentsResolver.search/3)
    end

    @desc "Fetch a specific document by ID"
    field :get_document, :document do
      arg(:id, :id)

      resolve(&DocumentsResolver.get/3)
    end
  end

  mutation do
    @desc "Create a new document"
    field :create_document, :document do
      arg(:document, non_null(:new_document))

      resolve(&DocumentsResolver.create/3)
    end

    @desc "Delete a document"
    field :delete_document, :document do
      arg(:id, non_null(:id))

      resolve(&DocumentsResolver.delete/3)
    end
  end
end
