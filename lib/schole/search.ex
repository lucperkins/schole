defmodule Schole.Search do
  @namespace "schole"

  alias Schole.Documents
  alias Schole.Documents.Document

  def search(query, opts \\ []) do
    case Algolia.search(@namespace, query, opts) do
      {:ok, res} -> handle_response(res)
      _ -> []
    end
  end

  def save_document(%Document{} = document) do
    Algolia.save_object(@namespace, document_item(document))
  end

  defp handle_response(res) do
    document_ids =
      res
      |> Map.get("hits")
      |> Enum.map(fn(hit) -> Map.get(hit, "objectId") end)
      |> Enum.map(&String.to_integer/1)

    documents = Documents.by_ids(document_ids)
  end

  defp document_item(%Document{title: title, url: url, tags: tags}) do
    %{
      title: title,
      url: url,
      tags: tags,
    }
  end
end
