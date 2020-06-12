defmodule Schole.Documents.DocumentsTest do
  use Schole.DataCase

  alias Schole.Documents
  alias Schole.Documents.Document

  @meta %{foo: "bar"}
  @url "/foo/bar"
  @valid %{title: "Some document title", content: "Some content", url: @url, metadata: @meta}
  @no_title %{content: "Some content", url: "/intro", metadata: @meta}
  @no_content %{
    title: "Some document title",
    url: "/intro",
    metadata: @meta
  }

  describe "documents" do
    test "all/0 returns an empty list" do
      assert [] = Documents.all()
    end

    test "create/1 succesfully creates a Document when attributes are valid" do
      new_doc = %{document: @valid}
      assert {:ok, %Document{} = document} = Documents.create(new_doc)
      assert document.url == @valid.url
      assert document.title == @valid.title
      assert document.content == @valid.content
      assert document.metadata == @valid.metadata
      assert document.tags == []
    end

    test "create/1 fails on missing title" do
      new_doc = %{document: @no_title}
      assert {:error, %Ecto.Changeset{} = changeset} = Documents.create(new_doc)
      expect_invalid(changeset, %{title: ["can't be blank"]})
    end

    test "create/1 fails on missing content" do
      new_doc = %{document: @no_content}
      assert {:error, %Ecto.Changeset{} = changeset} = Documents.create(new_doc)
      expect_invalid(changeset, %{content: ["can't be blank"]})
    end
  end
end
