defmodule ScholeWeb.Schema do
  @moduledoc false

  use Absinthe.Schema
  import_types(ScholeWeb.Schema.ContentTypes)

  alias ScholeWeb.Resolvers.{DocumentsResolver, ProjectsResolver}

  query do
    @desc "Find a project by some combination of ID, title, slug, and tags"
    field :find_projects, :project do
      arg(:id, :id)
      arg(:title, :string)
      arg(:slug, :string)
      arg(:tags, list_of(:string))

      resolve(&ProjectsResolver.find/3)
    end

    @desc "Find a document by some combination of title, single tag, or multiple tags"
    field :find_documents, list_of(:document) do
      arg(:id, :id)
      arg(:title, :string)
      arg(:slug, :string)
      arg(:query, :string)
      arg(:tags, list_of(:string))

      resolve(&DocumentsResolver.find/3)
    end
  end

  mutation do
    @desc "Create a new project"
    field :create_project, :project do
      arg(:new_project, non_null(:new_project))

      resolve(&ProjectsResolver.create/3)
    end

    @desc "Create a new document"
    field :create_document, :document do
      arg(:new_document, non_null(:new_document))

      resolve(&DocumentsResolver.create/3)
    end
  end
end
