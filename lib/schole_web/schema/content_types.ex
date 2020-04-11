defmodule ScholeWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  object :project do
    field :id, :id
    field :slug, :string
    field :title, :string
  end
end
