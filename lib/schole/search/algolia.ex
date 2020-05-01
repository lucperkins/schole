defmodule Schole.Search.Algolia do
  @moduledoc false

  @behaviour Schole.Search

  @namespace "schole"

  alias Schole.Documents
  alias Schole.Documents.Document

  def search(query) do
    case Algolia.search(@namespace, query, []) do
      {:ok, res} -> handle_response(res)
      _ -> []
    end
  end

  def index(%Document{id: id} = document) do
    case Algolia.save_object(@namespace, document_item(document), id) do
      {:ok, _} -> {:ok, document}
      {:error, reason} -> {:error, reason}
    end
  end

  defp handle_response(%{"hits" => hits}) when hits == [], do: []

  defp handle_response(%{"hits" => hits}) do
    document_ids =
      hits
      |> Enum.map(fn hit -> Map.get(hit, "objectID") end)
      |> Enum.map(&String.to_integer/1)

    Documents.by_ids(document_ids)
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
