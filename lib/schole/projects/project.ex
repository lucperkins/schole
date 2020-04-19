defmodule Schole.Projects.Project do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Schole.Documents.Document
  alias Schole.Helpers
  alias Schole.Projects.Project

  @required ~w(title)a
  @optional ~w(metadata slug)a

  schema "projects" do
    field :slug, :string
    field :title, :string, null: false
    field :metadata, :map, default: %{}
    has_many :documents, Document
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
