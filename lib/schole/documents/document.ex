defmodule Schole.Documents.Document do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Schole.Documents.Document
  alias Schole.Helpers
  alias Schole.Projects.Project

  @required ~w(title content url)a
  @optional ~w(description metadata tags)a
  @url_regex ~r/^\/([A-z0-9-_+]+\/)*([A-z0-9]+)$/

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
    |> unique_constraint(:url,
      name: :index_version_for_project,
      message: "Release notes for that version and project already exist")
    |> Helpers.format_url()
    |> validate_format(:url, @url_regex, message: "Invalid URL (must be of the form /a/b/c)")
  end
end
