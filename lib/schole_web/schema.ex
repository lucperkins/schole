defmodule ScholeWeb.Schema do
  use Absinthe.Schema
  import_types ScholeWeb.Schema.ContentTypes

  alias ScholeWeb.Resolvers.ProjectsResolver

  query do
    @desc "Get all projects"
    field :projects, list_of(:project) do
      resolve &ProjectsResolver.all/3
    end

    @desc "Find a project by some combination of ID, title, and slug"
    field :find_project, :project do
      arg :id, :id
      arg :title, :string
      arg :slug, :string

      resolve &ProjectsResolver.find/3
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
  end
end
