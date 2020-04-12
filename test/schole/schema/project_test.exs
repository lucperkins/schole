defmodule Schole.Schema.ProjectTest do
  use Schole.DataCase

  alias Schole.Projects.Project

  @meta %{foo: "bar", baz: 100, bop: [10]}
  @valid %{title: "Some title", slug: "some-slug", metadata: @meta}
  @no_slug %{title: "Some title", metadata: @meta}
  @no_meta %{title: "Some title"}
  @no_title %{slug: "slug-only", metadata: @meta}

  test "valid with valid params" do
    changeset = create_changeset(@valid)
    expect_valid(changeset)
  end

  test "valid without slug" do
    changeset = create_changeset(@no_slug)
    expect_valid(changeset)
  end

  test "valid without metadata" do
    changeset = create_changeset(@no_meta)
    expect_valid(changeset)
  end

  test "invalid without title" do
    changeset = create_changeset(@no_title)
    expect_invalid(changeset, %{title: ["can't be blank"]})
  end

  defp create_changeset(attrs) do
    Project.create_changeset(%Project{}, attrs)
  end
end
