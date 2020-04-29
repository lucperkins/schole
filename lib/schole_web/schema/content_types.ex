defmodule ScholeWeb.Schema.ContentTypes do
  @moduledoc false

  use Absinthe.Schema.Notation
  import_types(ScholeWeb.Schema.JSONScalar)
  alias Schole.Repo
  alias ScholeWeb.Resolvers.DocumentsResolver

  @desc "A Schole documentation project"
  object :project do
    @desc "The project's unique identifier"
    field :id, non_null(:id)

    @desc "The unique slug for the project, e.g. my-docs-project"
    field :slug, non_null(:string)

    @desc "The unique title for the project, e.g. 'My Docs Project'"
    field :title, non_null(:string)

    @desc "Key-value metadata associated with the project"
    field :metadata, :json

    @desc "Descriptive tags for indexing the project"
    field :tags, list_of(:string)

    @desc "The documents associated with the project"
    field :documents, list_of(:document) do
      resolve(fn project, _, _ ->
        documents =
          project
          |> Ecto.assoc(:documents)
          |> Repo.all()

        {:ok, documents}
      end)
    end

    @desc "Release notes associated with the project"
    field :release_notes, list_of(:release_note) do
      resolve(fn project, _, _ ->
        release_notes =
          project
          |> Ecto.assoc(:release_notes)
          |> Repo.all()

        {:ok, release_notes}
      end)
    end
  end

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

    @desc "The project under which the document exists"
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

  @desc "Version-specific notes for the Schole project"
  object :release_note do
    @desc "The release notes' unique identifier"
    field :id, non_null(:id)

    @desc "The project version associated with the release notes"
    field :version, non_null(:string)

    @desc "The notes content for this version of the project"
    field :notes, non_null(:string)

    @desc "The project under which the release notes exist"
    field :project, :project do
      resolve(fn release_note, _, _ ->
        project =
          release_note
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
  end

  input_object :new_release_note do
    field :version, non_null(:string)
    field :notes, non_null(:string)
  end
end
