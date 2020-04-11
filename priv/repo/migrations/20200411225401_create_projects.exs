defmodule Schole.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :slug, :string, null: false
      add :title, :string, null: false
      add :metadata, :map, default: %{}
    end

    create unique_index(:projects, [:title])
    create unique_index(:projects, [:slug])
  end
end
