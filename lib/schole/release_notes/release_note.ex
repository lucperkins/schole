defmodule Schole.ReleaseNotes.ReleaseNote do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Schole.ReleaseNotes.ReleaseNote
  alias Schole.Projects.Project

  @required ~w(version notes repo)a
  @optional ~w(pull_request_id)a
  @version_regex ~r/^(\d+\.)*(\d)$/

  schema "release_notes" do
    field :version, :string, null: false
    field :notes, :string, null: false
    field :repo, :string
    field :pull_request_id, :integer
    belongs_to :project, Project
  end

  def create_changeset(%ReleaseNote{} = release_note, attrs \\ %{}, %Project{} = project) do
    release_note
    |> cast(attrs, @required ++ @optional)
    |> put_assoc(:project, project)
    |> unique_constraint(:version,
      name: :index_url_for_project,
      message: "A document with that URL already exists for this project")
    |> validate_required(@required)
    |> validate_format(:version, @version_regex, message: "Not a valid version")
  end
end
