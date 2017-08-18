defmodule DdtWeb.PageController do
  use DdtWeb, :controller

  plug Plugs.RecordMetrics

  def index(conn, _params) do
    render conn, "index.html"
  end
end
