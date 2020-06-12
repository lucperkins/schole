defmodule Schole.Search do
  @moduledoc false

  @default_driver Schole.Search.Postgres.ILike

  alias Schole.Documents.Document

  @callback search(String) :: [Document]

  @spec search(String) :: [Document]
  def search(query) when query == "", do: []

  def search(query) do
    driver = select_search_driver()
    driver.search(query)
  end

  @spec index(Document) :: {:ok, Document} | {:error, term}
  def index(document) do
    driver = select_search_driver()
    driver.index(document)
  end

  @spec select_search_driver() :: Search
  defp select_search_driver() do
    Application.get_env(:schole, __MODULE__, @default_driver)
  end
end
