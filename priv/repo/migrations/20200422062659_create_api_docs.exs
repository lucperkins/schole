defmodule Schole.Repo.Migrations.CreateApis do
  use Ecto.Migration

  alias Schole.Api.ApiDocs.FormatEnum

  def change do
    create table(:api_docs) do
      add :slug, :string, null: false
      add :format, FormatEnum.type(), null: false, default: "openapi"
      add :document, :map, null: false
      add :project_id, references(:projects)
    end

    create unique_index(:api_docs, [:slug, :project_id], name: :index_slug_for_project)
  end
end
