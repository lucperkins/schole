defmodule Schole.Helpers do
  @moduledoc false

  import Ecto.Changeset

  def format_url(%Ecto.Changeset{changes: %{url: url}} = changeset) do
    case String.at(url, -1) do
      "/" ->
        url = String.replace_suffix(url, "/", "")
        put_change(changeset, :url, url)

      _ ->
        changeset
    end
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
