defmodule ScholeWeb.Schema do
  use Absinthe.Schema
  import_types ScholeWeb.Schema.ContentTypes

  alias ScholeWeb.Resolvers.{DocumentsResolver, ProjectsResolver}

  query do
    @desc "Get all projects"
    field :projects, list_of(:project) do
      resolve &ProjectsResolver.all/3
    end

    @desc "Find a project by some combination of ID, title, slug, and tag"
    field :find_project, :project do
      arg :id, :id
      arg :title, :string
      arg :slug, :string

      resolve &ProjectsResolver.find/3
    end

    @desc "Get all documents"
    field :documents, list_of(:document) do
      resolve &DocumentsResolver.all/3
    end

    @desc "Find a document by some combination of title, single tag, or multiple tags"
    field :find_documents, list_of(:document) do
      arg :title, :string
      arg :tags, list_of(:string)

      resolve &DocumentsResolver.find/3
    end

    @desc "Search documents"
    field :search_documents, list_of(:document) do
      arg :query, non_null(:string)

      resolve &DocumentsResolver.search/3
    end
  end

  mutation do
    @desc "Create a new project"
    field :create_project, :project do
      arg :title, non_null(:string)
      arg :slug, :string
      arg :metadata, :json

      resolve &ProjectsResolver.create/3
    end

    @desc "Create a new document"
    field :create_document, :document do
      arg :title, non_null(:string)
      arg :url, non_null(:string)
      arg :content, non_null(:string)
      arg :project_id, non_null(:id)
      arg :description, :string
      arg :metadata, :json
      arg :tags, list_of(:string)

      resolve &DocumentsResolver.create/3
    end
  end
end
