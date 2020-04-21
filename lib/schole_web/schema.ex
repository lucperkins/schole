defmodule ScholeWeb.Schema do
  @moduledoc false

  use Absinthe.Schema
  import_types(ScholeWeb.Schema.ContentTypes)

  alias ScholeWeb.Resolvers.{DocumentsResolver, ProjectsResolver}

  query do
    @desc "Find a project by some combination of ID, title, slug, and tags"
    field :find_projects, list_of(:project) do
      arg :id, :id
      arg :title, :string
      arg :slug, :string
      arg :tags, list_of(:string)

      resolve &ProjectsResolver.find/3
    end

    @desc "Find documents on the basis of some combination of title, tags, or text query string"
    field :find_documents, list_of(:document) do
      arg :title, :string
      arg :tags, list_of(:string)
      arg :query, :string

      resolve &DocumentsResolver.find/3
    end

    @desc "Fetch a specific document by ID"
    field :get_document, :document do
      arg :id, :id

      resolve &DocumentsResolver.get/3
    end
  end

  mutation do
    @desc "Create a new project"
    field :create_project, :project do
      arg :new_project, non_null(:new_project)

      resolve &ProjectsResolver.create/3
    end

    @desc "Delete a project"
    field :delete_project, :project do
      arg :id, non_null(:id)

      resolve &ProjectsResolver.delete/3
    end

    @desc "Create a new document"
    field :create_document, :document do
      arg :new_document, non_null(:new_document)

      resolve &DocumentsResolver.create/3
    end

    @desc "Delete a document"
    field :delete_document, :document do
      arg :id, non_null(:id)

      resolve &DocumentsResolver.delete/3
    end
  end
end
