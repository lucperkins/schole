defmodule Schole.Factory do
  use ExMachina.Ecto, repo: Schole.Repo

  alias Schole.Projects.Project

  def valid_project_factory do
    %Project{
      title: "My Project",
      metadata: %{
        foo: "bar",
        baz: 100
      }
    }
  end
end
