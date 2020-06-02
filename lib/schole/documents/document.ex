defmodule Schole.Documents.Document do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Schole.Documents.Document
  alias Schole.Helpers

  @required ~w(title content)a
  @optional ~w(description metadata tags url)a
  @url_regex ~r/^\/([A-z0-9-_+]+\/)*([A-z0-9]+)$/

  schema "documents" do
    field :title, :string, null: false
    field :url, :string
    field :description, :string
    field :content, :string, null: false
    field :metadata, :map, default: %{}
    field :tags, {:array, :string}, default: []
  end

  def create_changeset(attrs \\ %{}) do
    %Document{}
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> Helpers.format_url()
    |> validate_format(:url, @url_regex, message: "Invalid URL (must be of the form /a/b/c)")
  end
end
