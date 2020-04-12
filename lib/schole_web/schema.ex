defmodule ScholeWeb.Schema do
  use Absinthe.Schema
  import_types ScholeWeb.Schema.ContentTypes

  alias ScholeWeb.Resolvers

  query do
    @desc "Get all projects"
    field :projects, list_of(:project) do
      resolve &Resolvers.Projects.list_projects/3
    end

    @desc "Get project"
    field :get_project, :project do
      arg :id, :id
      arg :title, :string
      arg :slug, :string

      resolve &Resolvers.Projects.get_project/3
    end
  end
end
