defmodule ScholeWeb.Schema.ContentTypes do
  @moduledoc false

  use Absinthe.Schema.Notation
  import_types(ScholeWeb.Schema.JSONScalar)
  alias Schole.Repo

  object :project do
    field :id, :id
    field :slug, :string
    field :title, :string
    field :metadata, :json
    field :tags, list_of(:string)

    field :documents, list_of(:document) do
      resolve(fn project, _, _ ->
        documents =
          project
          |> Ecto.assoc(:documents)
          |> Repo.all()

        {:ok, documents}
      end)
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
      resolve(fn document, _, _ ->
        project =
          document
          |> Ecto.assoc(:project)
          |> Repo.one()

        {:ok, project}
      end)
    end
  end

  input_object :new_project do
    field :title, non_null(:string)
    field :slug, :string
    field :metadata, :json
  end

  input_object :new_document do
    field :title, non_null(:string)
    field :url, non_null(:string)
    field :description, :string
    field :content, non_null(:string)
    field :metadata, :json
    field :tags, list_of(:string)
    field :project_id, non_null(:id)
  end
end
