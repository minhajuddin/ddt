defmodule DdtWeb.PageController do
  use DdtWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
