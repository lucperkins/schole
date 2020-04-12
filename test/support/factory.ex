defmodule Schole.Factory do
  use ExMachina.Ecto, repo: Schole.Repo

  alias Schole.Projects.Project

  def project_factory do
    %Project{
      title: "Some project name",
      slug: "some-slug",
      metadata: %{
        foo: "bar",
        baz: 100
      }
    }
  end
end
