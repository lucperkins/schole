defmodule Schole.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :title, :string, null: false
      add :description, :string
      add :content, :string, null: false
      add :metadata, :map
      add :tags, {:array, :string}, default: []
    end
  end
end
