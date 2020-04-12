defmodule ScholeWeb.Schema.JSONScalar do
  @moduledoc """
  The Json scalar type allows arbitrary JSON values to be passed in and out.
  Requires `{ :jason, "~> 1.1" }` package: https://github.com/michalmuskala/jason
  """
  use Absinthe.Schema.Notation

  alias Absinthe.Blueprint.Input.{String, Null}

  scalar :json, name: "Json" do
    description("""
    The `Json` scalar type represents arbitrary JSON string data, represented as UTF-8
    character sequences. The `Json` type is most often used to represent a free-form
    human-readable JSON string.
    """)

    serialize(&encode/1)
    parse(&decode/1)
  end

  @spec decode(String.t()) :: {:ok, term()} | :error
  @spec decode(Null.t()) :: {:ok, nil}
  defp decode(%String{value: value}) do
    case Jason.decode(value) do
      {:ok, result} -> {:ok, result}
      _ -> :error
    end
  end

  defp decode(%Null{}) do
    {:ok, nil}
  end

  defp decode(_) do
    :error
  end

  defp encode(value), do: value
end
