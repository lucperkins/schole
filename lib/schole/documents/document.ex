defmodule Schole.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  alias Schole.Documents.Document

  @required ~w(title content)a
  @optional ~w(description metadata tags)a

  schema "documents" do
    field :title, :string, null: false
    field :description, :string
    field :content, :string, null: false
    field :metadata, :map, default: %{}
    field :tags, {:array, :string}, default: []
  end

  def create_changeset(%Document{} = document, attrs \\ %{}) do
    document
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
