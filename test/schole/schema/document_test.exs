defmodule Schole.Schema.DocumentTest do
  use Schole.DataCase

  alias Schole.Documents.Document

  @meta %{foo: "bar"}
  @valid %{
    title: "Some doc title",
    content: "Some doc content",
    url: "/deploy",
    metadata: @meta,
  }
  @no_title %{
    content: "Some doc content",
    url: "/deploy",
    metadata: @meta,
  }
  @no_content %{title: "Some doc title", url: "/deploy", metadata: @meta}

  test "valid with valid params" do
    changeset = make_changeset(@valid)
    expect_valid(changeset)
  end

  test "invalid without title or content" do
    changeset = make_changeset(@no_title)
    expect_invalid(changeset, %{title: ["can't be blank"]})

    changeset = make_changeset(@no_content)
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

  defp make_changeset(attrs) do
    Document.create_changeset(attrs)
  end

  # Expect invalid
  defp test_url(changeset, url, expected_error) do
    input = Map.put(changeset, :url, url)
    changeset = make_changeset(input)
    expect_invalid(changeset, expected_error)
  end

  # Expect valid
  defp test_url(changeset, url) do
    input = Map.put(changeset, :url, url)
    changeset = make_changeset(input)
    expect_valid(changeset)
  end
end
