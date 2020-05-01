defmodule Schole.Search do
  @moduledoc false

  @default_driver Schole.Search.Postgres.ILike

  alias Schole.Documents.Document

  @type query :: String
  @type documents :: [Document]
  @type document :: Document

  @callback search(query) :: documents

  @spec search(query) :: documents
  def search(query) do
    driver = select_search_driver()
    driver.search(query)
  end

  @spec index(document) :: {:ok, term} | {:error, term}
  def index(document) do
    driver = select_search_driver()
    driver.index(document)
  end

  defp select_search_driver() do
    Application.get_env(:schole, :search)[:driver] || @default_driver
  end
end
