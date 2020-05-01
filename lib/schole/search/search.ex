defmodule Schole.Search do
  @moduledoc false

  @default_driver Schole.Search.Postgres

  alias Schole.Documents.Document
  alias Schole.Search.Postgres

  @type query :: String
  @type documents :: [Document]

  @callback search(query) :: documents

  @spec search(query) :: documents
  def search(query) do
    driver = Application.get_env(:schole, :search)[:driver] || @default_driver
    driver.search(query)
  end
end
