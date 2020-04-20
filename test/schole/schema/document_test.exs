defmodule Schole.Schema.DocumentTest do
  use Schole.DataCase
  import Ecto.Changeset

  alias Schole.Documents.Document
  alias Schole.Projects.Project

  @meta %{foo: "bar"}
  @project_id 100
  @valid %{
    title: "Some doc title",
    content: "Some doc content",
    url: "/deploy",
    metadata: @meta,
    project_id: @project_id
  }
  @no_title %{
    content: "Some doc content",
    url: "/deploy",
    metadata: @meta,
    project_id: @project_id
  }
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

  test "valid URL accepted" do
    urls = ["/foo/bar", "/foo/bar/baz", "/foo/bar_baz", "/bar/foo/"]

    for url <- urls do
      test_url(@valid, url)
    end
  end

  test "invalid URL rejected" do
    urls = ["https://example.com", "foo/bar", "c://desktop", "foo bar"]

    for url <- urls do
      test_url(@valid, url, %{url: ["Invalid URL (must be of the form /a/b/c)"]})
    end
  end

  test "URL trailing slash removed" do
    in_url = "/foo/bar/"
    out_url = "/foo/bar"
    valid = %{title: "T", content: "C", url: in_url, project_id: @project_id}

    changeset = make_changeset(valid, @project)
    expect_valid(changeset)
    assert get_change(changeset, :url) == out_url
  end

  defp make_changeset(attrs, project) do
    Document.create_changeset(%Document{}, attrs, project)
  end

  # Expect invalid
  defp test_url(changeset, url, expected_error) do
    input = Map.put(changeset, :url, url)
    changeset = make_changeset(input, @project)
    expect_invalid(changeset, expected_error)
  end

  # Expect valid
  defp test_url(changeset, url) do
    input = Map.put(changeset, :url, url)
    changeset = make_changeset(input, @project)
    expect_valid(changeset)
  end
end
