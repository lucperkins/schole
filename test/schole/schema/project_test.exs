defmodule Schole.Schema.ProjectTest do
  use Schole.DataCase

  alias Schole.Projects.Project

  @meta %{foo: "bar", baz: 100, bop: [10]}
  @valid %{title: "Some title", slug: "some-slug", metadata: @meta}
  @valid_no_slug %{title: "Some title", metadata: @meta}
  @valid_no_meta %{title: "Some title"}
  @invalid_no_title %{slug: "slug-only", metadata: @meta}

  test "valid parameters" do
    changeset = create_changeset(@valid)
    expect_valid(changeset)
  end

  test "valid no slug" do
    changeset = create_changeset(@valid_no_slug)
    expect_valid(changeset)
  end

  test "valid no metadata" do
    changeset = create_changeset(@valid_no_meta)
    expect_valid(changeset)
  end

  test "invalid no title" do
    changeset = create_changeset(@invalid_no_title)
    expect_invalid(changeset, %{title: ["can't be blank"]})
  end

  defp create_changeset(attrs) do
    Project.create_changeset(%Project{}, attrs)
  end
end
