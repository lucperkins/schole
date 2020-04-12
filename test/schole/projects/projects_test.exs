defmodule Schole.Projects.ProjectsTest do
  use Schole.DataCase

  @meta %{foo: "bar"}
  @valid %{title: "Some title", slug: "some-slug", metadata: @meta}
  @no_slug %{title: "Some title", metadata: @meta}
  @same_title %{title: "Some title", slug: "brand-new-slug", metadata: @meta}
  @same_slug %{title: "Brand new title", slug: "some-slug", metadata: @meta}
  @non_existent_id 100

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

    test "create_project/1 fails on non-unique title, event with different slugs" do
      assert {:ok, %Project{} = project} = Projects.create_project(@valid)
      assert {:error, %Ecto.Changeset{} = changeset} = Projects.create_project(@same_title)
      expect_invalid(changeset, %{title: ["has already been taken"]})
    end

    test "create_project/1 fails on non-unique slug, event with different titles" do
      assert {:ok, %Project{} = project} = Projects.create_project(@valid)
      assert {:error, %Ecto.Changeset{} = changeset} = Projects.create_project(@same_slug)
      expect_invalid(changeset, %{slug: ["has already been taken"]})
    end

    test "create_project/1 automatically creates slug" do
      assert {:ok, %Project{} = project} = Projects.create_project(@no_slug)
      assert project.slug == "some-title"
    end

    test "delete_project/1 can't delete project that doesn't exist" do
      assert {:error, :not_found} = Projects.delete_project(@non_existent_id)
    end
  end
end
