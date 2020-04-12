defmodule ScholeWeb.GraphQLTest do
  use ScholeWeb.ConnCase, async: true
  import Schole.Factory
  alias ScholeWeb.Resolvers.Projects

  test "projects initially empty" do
    result = Projects.list_projects(nil, nil, nil)

    assert result == {:ok, []}
  end

  test "create project successful" do
    project = build(:valid_project)

    assert project.title == "Some project name"
  end
end
