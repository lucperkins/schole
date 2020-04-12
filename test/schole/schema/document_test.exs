defmodule Schole.Schema.DocumentTest do
  use Schole.DataCase

  alias Schole.Documents.Document

  @meta %{foo: "bar"}
  @valid %{title: "Some doc title", content: "Some doc content", metadata: @meta}
  @no_title %{content: "Some doc content", metadata: @meta}
  @no_content %{title: "Some doc title", metadata: @meta}

  test "valid with valid params" do
    changeset = create_changeset(@valid)
    expect_valid(changeset)
  end

  test "invalid without title or content" do
    changeset = create_changeset(@no_title)
    expect_invalid(changeset, %{title: ["can't be blank"]})

    changeset = create_changeset(@no_content)
    expect_invalid(changeset, %{content: ["can't be blank"]})
  end

  defp create_changeset(attrs) do
    Document.create_changeset(%Document{}, attrs)
  end
end
