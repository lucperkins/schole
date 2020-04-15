defmodule Schole.Schema.DocumentTest do
  use Schole.DataCase

  alias Schole.Documents.Document
  alias Schole.Projects.Project

  @meta %{foo: "bar"}
  @project_id 100
  @valid %{title: "Some doc title", content: "Some doc content", url: "/deploy", metadata: @meta, project_id: @project_id}
  @no_title %{content: "Some doc content", url: "/deploy", metadata: @meta, project_id: @project_id}
  @no_content %{title: "Some doc title", url: "/deploy", metadata: @meta, project_id: @project_id}
  @project %Project{}

  test "valid with valid params" do
    changeset = make_changeset(@valid, @project)
    expect_valid(changeset)
  end

  test "invalid without title or content" do
    changeset = make_changeset(@no_title, @project)
    expect_invalid(changeset, %{title: ["can't be blank"]})

    changeset = make_changeset(@no_content, @project)
    expect_invalid(changeset, %{content: ["can't be blank"]})
  end

  defp make_changeset(attrs, project) do
    Document.create_changeset(%Document{}, attrs, project)
  end
end
