defmodule ScholeWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation
  import_types ScholeWeb.Schema.JSONScalar

  object :project do
    field :id, :id
    field :slug, :string
    field :title, :string
    field :metadata, :json
  end
end
