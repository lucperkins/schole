defmodule Schole.Documents.DocumentsTest do
  use Schole.DataCase

  alias Schole.Documents
  alias Schole.Documents.Document
  alias Schole.Projects
  alias Schole.Projects.Project

  @meta %{foo: "bar"}
  @project_id 100
  @valid %{title: "Some document title", content: "Some content", url: "/intro", metadata: @meta}
  @no_title %{content: "Some content", url: "/intro", metadata: @meta }
  @no_content %{title: "Some document title", url: "/intro", metadata: @meta, project_id: @project_id}
  @project %{title: "Test project"}

  describe "documents" do
    test "all/0 returns an empty list" do
      assert [] = Documents.all()
    end

    test "create/1 succesfully creates a Document when attributes are valid" do
      {:ok, %Project{} = project} = Projects.create(@project)
      valid = Map.merge(@valid, %{project_id: project.id})

      assert {:ok, %Document{} = document} = Documents.create(valid)
      assert document.url == @valid.url
      assert document.title == @valid.title
      assert document.content == @valid.content
      assert document.metadata == @valid.metadata
      assert document.tags == []
    end

    test "create/1 fails on missing title" do
      {:ok, %Project{} = project} = Projects.create(@project)
      no_title = Map.merge(@no_title, %{project_id: project.id})

      assert {:error, %Ecto.Changeset{} = changeset} = Documents.create(no_title)
      expect_invalid(changeset, %{title: ["can't be blank"]})
    end

    test "create/1 fails on missing content" do
      {:ok, %Project{} = project} = Projects.create(@project)
      no_content = Map.merge(@no_content, %{project_id: project.id})

      assert {:error, %Ecto.Changeset{} = changeset} = Documents.create(no_content)
      expect_invalid(changeset, %{content: ["can't be blank"]})
    end
  end
end
