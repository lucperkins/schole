defmodule ScholeWeb.PageController do
  use ScholeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
