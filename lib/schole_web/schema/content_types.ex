defmodule ScholeWeb.Schema.ContentTypes do
  @moduledoc false

  use Absinthe.Schema.Notation
  import_types(ScholeWeb.Schema.JSONScalar)

  @desc "The core document type for Schole documentation"
  object :document do
    @desc "The document's unique identifier"
    field :id, non_null(:id)

    @desc "The title for the document, e.g. 'Deployment Guide'"
    field :title, non_null(:string)

    @desc "The URL for the document within the project, e.g. /deploy/kubernetes"
    field :url, non_null(:string)

    @desc "A description for the document"
    field :description, :string

    @desc "The document's main markup content"
    field :content, non_null(:string)

    @desc "Key-value metadata associated with the document"
    field :metadata, :json

    @desc "Descriptive tags for indexing the document"
    field :tags, list_of(:string)
  end

  input_object :new_document do
    field :title, non_null(:string)
    field :url, non_null(:string)
    field :description, :string
    field :content, non_null(:string)
    field :metadata, :json
    field :tags, list_of(:string)
  end
end
