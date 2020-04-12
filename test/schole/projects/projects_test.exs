defmodule Schole.Projects.ProjectsTest do
  use Schole.DataCase
  import Schole.Factory
  alias Schole.Projects

  describe "projects" do
    alias Schole.Projects.Project

    test "valid project" do
      project = build(:valid_project)
      assert project.title == "Some project name"
    end
  end
end
