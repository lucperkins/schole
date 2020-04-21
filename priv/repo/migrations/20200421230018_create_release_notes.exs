defmodule Schole.Repo.Migrations.CreateReleaseNotes do
  use Ecto.Migration

  def change do
    create table(:release_notes) do
      add :version, :string, null: false
      add :notes, :text, null: false
      add :repo, :string
      add :pull_request_id, :integer
      add :project_id, references(:projects)
    end

    create unique_index(:release_notes, [:version, :project_id], name: :index_version_for_project)
  end
end
