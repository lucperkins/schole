defmodule Schole.Projects.Project do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Schole.Api.ApiDocs
  alias Schole.Documents.Document
  alias Schole.Helpers
  alias Schole.Projects.Project
  alias Schole.ReleaseNotes.ReleaseNote

  @required ~w(title)a
  @optional ~w(metadata slug)a

  schema "projects" do
    field :slug, :string
    field :title, :string, null: false
    field :metadata, :map, default: %{}
    has_many :documents, Document
    has_many :release_notes, ReleaseNote
    has_many :api_docs, ApiDocs
  end

  def create_changeset(%Project{} = project, attrs \\ %{}) do
    project
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> unique_constraint(:title,
      name: :projects_title_index,
      message: "a project with that title already exists"
    )
    |> unique_constraint(:slug,
      name: :projects_slug_index,
      message: "a project with that slug already exists"
    )
    |> Helpers.set_project_slug()
  end
end
