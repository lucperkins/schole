defmodule Schole.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  alias Schole.Projects.Project

  @required ~w(title)a
  @optional ~w(metadata slug)a
  #@unique ~w(slug title)

  schema "projects" do
    field :slug, :string
    field :title, :string, null: false
    field :metadata, :map, default: %{}
  end

  def create_changeset(%Project{} = project, attrs \\ %{}) do
    project
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> unique_constraint(:title, name: :projects_title_index)
    |> unique_constraint(:slug, name: :projects_slug_index)
    |> set_project_slug()
  end

  def set_project_slug(changeset) do
    if changeset.valid? do
      case get_change(changeset, :slug) do
        nil ->
          title = get_change(changeset, :title)
          put_change(changeset, :slug, Slug.slugify(title))
        slug ->
          put_change(changeset, :slug, Slug.slugify(slug))
      end
    else
      changeset
    end
  end
end
