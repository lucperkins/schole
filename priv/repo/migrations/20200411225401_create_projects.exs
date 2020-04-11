defmodule Schole.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :slug, :string, null: false
      add :title, :string, null: false
      add :metadata, :map
      add :content, :string, null: false
    end

    create unique_index(:projects, [:slug])
  end
end
