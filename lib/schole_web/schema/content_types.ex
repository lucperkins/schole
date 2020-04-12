defmodule ScholeWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation
  import_types ScholeWeb.Schema.JSONScalar

  object :project do
    field :id, :id
    field :slug, :string
    field :title, :string
    field :metadata, :json
  end

  object :document do
    field :id, :id
    field :title, :string
    field :description, :string
    field :content, :string
    field :metadata, :json
    field :tags, list_of(:string)
  end
end
