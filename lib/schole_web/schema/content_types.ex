defmodule ScholeWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation
  import_types ScholeWeb.Schema.JSONScalar
  alias Schole.Repo

  object :project do
    field :id, :id
    field :slug, :string
    field :title, :string
    field :metadata, :json
    field :documents, list_of(:document) do
      resolve fn project, _, _ ->
        documents =
          project
          |> Ecto.assoc(:documents)
          |> Repo.all()

        {:ok, documents}
      end
    end
  end

  object :document do
    field :id, :id
    field :title, :string
    field :url, :string
    field :description, :string
    field :content, :string
    field :metadata, :json
    field :tags, list_of(:string)
    field :project, :project do
      resolve fn document, _, _ ->
        project =
          document
          |> Ecto.assoc(:project)
          |> Repo.one()
        {:ok, project}
      end
    end
  end
end
