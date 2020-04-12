defmodule Schole.Projects.ProjectsTest do
  use Schole.DataCase

  @meta %{foo: "bar"}
  @valid %{title: "Some title", slug: "some-slug", metadata: @meta}
  @no_slug %{title: "Some title", metadata: @meta}
  @same_title %{title: "Some title", slug: "brand-new-slug", metadata: @meta}
  @same_slug %{title: "Brand new title", slug: "some-slug", metadata: @meta}

  describe "projects" do
    alias Schole.Projects
    alias Schole.Projects.Project

    test "list_projects/0 returns an empty list" do
      assert [] == Projects.all()
    end

    test "create/1 successfully creates project" do
      assert {:ok, %Project{} = project} = Projects.create(@valid)
      assert project.title == "Some title"
      assert project.slug == "some-slug"
      assert project.metadata == %{foo: "bar"}
    end

    test "create/1 fails on non-unique title, event with different slugs" do
      assert {:ok, %Project{} = project} = Projects.create(@valid)
      assert {:error, %Ecto.Changeset{} = changeset} = Projects.create(@same_title)
      expect_invalid(changeset, %{title: ["a project with that title already exists"]})
    end

    test "create/1 fails on non-unique slug, event with different titles" do
      assert {:ok, %Project{} = project} = Projects.create(@valid)
      assert {:error, %Ecto.Changeset{} = changeset} = Projects.create(@same_slug)
      expect_invalid(changeset, %{slug: ["a project with that slug already exists"]})
    end

    test "create/1 automatically creates slug" do
      assert {:ok, %Project{} = project} = Projects.create(@no_slug)
      assert project.slug == "some-title"
    end
  end
end
