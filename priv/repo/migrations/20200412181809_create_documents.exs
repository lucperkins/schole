defmodule Schole.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :title, :string, null: false
      add :url, :string
      add :description, :string
      add :content, :string, null: false
      add :metadata, :map, default: %{}
      add :tags, {:array, :string}, default: []
    end
  end
end
