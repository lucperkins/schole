defmodule Schole.Projects.ProjectsTest do
  use Schole.DataCase

  #@project build(:project)

  describe "projects" do
    alias Schole.Projects

    test "list_projects/0 returns an empty list" do
      assert [] == Projects.list_projects
    end

    test "create_project/1 returns the project" do
      project = insert(:project)
    end
  end
end
