defmodule Schole.Search do
  @namespace "schole"

  alias Schole.Documents
  alias Schole.Documents.Document

  def search(query) do
    case Algolia.search(@namespace, query, []) do
      {:ok, res} -> handle_response(res)
      _ -> []
    end
  end

  def save_document(%Document{id: id} = document) do
    Algolia.save_object(@namespace, document_item(document), id)
  end

  defp handle_response(%{"hits" => hits} = res) do
    case hits do
      [] -> []
      _hits ->
        document_ids =
          res
          |> Map.get("hits")
          |> Enum.map(fn(hit) -> Map.get(hit, "objectID") end)
          |> Enum.map(&String.to_integer/1)

        Documents.by_ids(document_ids)
    end
  end

  defp document_item(%Document{title: title, url: url, tags: tags, content: content}) do
    %{
      title: title,
      url: url,
      tags: tags,
      content: content
    }
  end
end
