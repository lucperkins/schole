defmodule ScholeWeb.Resolvers.Helpers do
  @moduledoc false

  alias Ecto.Changeset

  def format_errors(changeset) do
    errors =
      Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {k, v}, formatted_msg ->
          formatted_msg |> String.replace("%{#{k}}", to_string(v))
        end)
      end)

    %{
      message: "Validation errors occurred",
      code: :schema_errors,
      errors: errors
    }
  end

  def wrapped_call(fun) do
    case fun.() do
      {:ok, result} -> {:ok, result}
      {:error, %Changeset{} = changeset} -> {:error, format_errors(changeset)}
      {:error, msg} -> {:error, msg}
    end
  end

  def wrapped_call(fun, msg) do
    case fun.() do
      nil -> {:error, msg}
      result -> {:ok, result}
    end
  end
end
