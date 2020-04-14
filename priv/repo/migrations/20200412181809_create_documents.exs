defmodule Schole.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :title, :string, null: false
      add :url, :string, null: false
      add :description, :string
      add :content, :string, null: false
      add :metadata, :map, default: %{}
      add :tags, {:array, :string}, default: []
      add :project_id, references(:projects)
    end

    create unique_index(:documents, [:url, :project_id], name: :index_url_for_project)
  end
end
