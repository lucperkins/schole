defmodule Schole.Documents.DocumentsTest do
  use Schole.DataCase

  alias Schole.Documents
  alias Schole.Documents.Document

  @meta %{foo: "bar"}
  @valid %{title: "Some document title", content: "Some content", metadata: @meta}

  describe "documents" do
    test "all/0 returns an empty list" do
      assert [] = Documents.all()
    end

    test "create/1 succesfully creates a Document when attributes are valid" do
      assert {:ok, %Document{} = document} = Documents.create(@valid)
      assert document.title == @valid.title
      assert document.content == @valid.content
      assert document.metadata == @valid.metadata
      assert document.tags == []
    end
  end
end
