defmodule ScholeWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  object :project do
    field :id, :id
  end
end
