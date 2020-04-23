defmodule Schole.Api.ApiDocs do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Schole.Api.ApiDocs
  alias Schole.Helpers
  alias Schole.Projects.Project

  @required ~w(slug format document)a

  defmodule FormatEnum do
    @moduledoc false
    use EctoEnum, openapi: "openapi"
  end

  schema "api_docs" do
    field :slug, :string, null: false
    field :format, FormatEnum, null: false, default: "openapi"
    field :document, :map, null: false
    belongs_to :project, Project
  end

  def create_changeset(%ApiDocs{} = api_docs, attrs \\ %{}, %Project{} = project) do
    api_docs
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> put_assoc(:project, project)
    |> Helpers.format_slug()
  end
end
