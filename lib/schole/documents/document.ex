defmodule Schole.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  alias Schole.Documents.Document
  alias Schole.Projects.Project

  @required ~w(title content url)a
  @optional ~w(description metadata tags)a

  schema "documents" do
    field :title, :string, null: false
    field :url, :string, null: false
    field :description, :string
    field :content, :string, null: false
    field :metadata, :map, default: %{}
    field :tags, {:array, :string}, default: []
    belongs_to :project, Project
  end

  def create_changeset(%Document{} = document, attrs \\ %{}, %Project{} = project) do
    document
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> put_assoc(:project, project)
    |> unique_constraint(:url, name: :index_url_for_project, message: "A document with that URL already exists for this project")
    |> validate_format(:url, ~r/\/([A-z0-9-_+]+\/)*([A-z0-9]+)$/)
  end
end
