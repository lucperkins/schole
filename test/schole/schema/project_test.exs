defmodule Schole.Schema.ProjectTest do
  use Schole.DataCase

  alias Schole.Projects.Project

  @valid %{title: "Some title", slug: "some-slug", metadata: %{foo: "bar", baz: 100, bop: [10]}}
  @invalid_no_title %{slug: "slug-only"}
  @no_slug %{title: "No slug provided"}

  test "valid parameters" do
    changeset = Project.create_changeset(%Project{}, @valid)
    expect_valid(changeset)
  end

  test "invalid no title" do
    changeset = Project.create_changeset(%Project{}, @invalid_no_title)
    expect_invalid(changeset, %{title: ["can't be blank"]})
  end

  test "automatic slug" do
    changeset = Project.create_changeset(%Project{}, @no_slug)
    expect_valid(changeset)
  end
end
