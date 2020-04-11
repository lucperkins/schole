defmodule ScholeWeb.Schema do
  use Absinthe.Schema
  import_types ScholeWeb.Schema.ContentTypes

  alias ScholeWeb.Resolvers

  query do
    @desc "Get all projects"
    field :projects, list_of(:project) do
      resolve &Resolvers.Projects.list_projects/3
    end
  end
end
