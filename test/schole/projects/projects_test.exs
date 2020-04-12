defmodule Schole.Projects.ProjectsTest do
  use Schole.DataCase

  @valid %{title: "Some title", slug: "some-slug", metadata: %{foo: "bar"}}

  describe "projects" do
    alias Schole.Projects
    alias Schole.Projects.Project

    test "list_projects/0 returns an empty list" do
      assert [] == Projects.list_projects
    end

    test "create_project/1 successfully creates project" do
      assert {:ok, %Project{} = project} = Projects.create_project(@valid)
      assert project.title == "Some title"
      assert project.slug == "some-slug"
      assert project.metadata == %{foo: "bar"}
    end

    test "create_project/1 fails on non-unique slug" do
      assert {:ok, _} = Projects.create_project(@valid)
      assert {:error, %Ecto.Changeset{} = errors} = Projects.create_project(@valid)
      expect_invalid(errors, %{title: ["has already been taken"]})
    end

    test "create_project/1 fails on non-unique title" do
      assert {:ok, _} = Projects.create_project(@valid)
      new_slug = Map.put(@valid, :title, "Some new title")

      assert {:error, %Ecto.Changeset{} = errors} = Projects.create_project(new_slug)
      expect_invalid(errors, %{slug: ["has already been taken"]})
    end
  end
end
