defmodule Schole.Helpers do
  @moduledoc false

  import Ecto.Changeset

  def format_url(%Ecto.Changeset{changes: %{url: url}} = changeset) do
    case String.at(url, -1) do
      "/" ->
        url = String.replace_suffix(url, "/", "")
        put_change(changeset, :url, url)

      _ ->
        changeset
    end
  end

  def format_url(changeset), do: changeset
end
