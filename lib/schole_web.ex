defmodule ScholeWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: ScholeWeb

      import Plug.Conn
      import ScholeWeb.Gettext
      alias ScholeWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/schole_web/templates",
        namespace: ScholeWeb

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      use Phoenix.HTML

      import ScholeWeb.ErrorHelpers
      import ScholeWeb.Gettext
      alias ScholeWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ScholeWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
