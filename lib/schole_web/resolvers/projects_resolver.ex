defmodule ScholeWeb.Resolvers.ProjectsResolver do
  alias Ecto.Changeset
  alias Schole.Projects

  def all(_parent, _args, _resolution) do
    projects = Projects.all

    {:ok, projects}
  end

  def find(_parent, args, _resolution) do
    case Projects.find(args) do
      nil -> {:error, "No project with those attributes found"}
      project -> {:ok, project}
    end
  end

  def create(_parent, args, _resolution) do
    wrapped_call(fn -> Projects.create(args) end)
  end

  defp format_errors(changeset) do
    errors = Changeset.traverse_errors(changeset, fn {msg, opts} ->
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

  defp wrapped_call(fun) do
    case fun.() do
      {:ok, result} -> {:ok, result}
      {:error, %Changeset{} = changeset} -> {:error, format_errors(changeset)}
    end
  end
end
