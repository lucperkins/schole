defmodule Schole.Schema.ProjectTest do
  use Schole.DataCase

  alias Schole.Projects.Project

  @valid %{title: "Some title", slug: "some-slug", metadata: %{foo: "bar", baz: 100, bop: [10]}}
  @invalid_no_title %{slug: "slug-only"}

  test "valid parameters" do
    changeset = create_changeset(@valid)
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
