defmodule Schole.Projects.ProjectsTest do
  use Schole.DataCase

  #@project build(:project)

  describe "projects" do
    alias Schole.Projects

    test "list_projects/0 returns an empty list" do
      assert [] == Projects.list_projects
    end
  end
end
