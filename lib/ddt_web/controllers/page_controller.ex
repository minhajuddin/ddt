defmodule DdtWeb.PageController do
  use DdtWeb, :controller

  plug Plugs.RecordMetrics

  def index(conn, _params) do
    :timer.sleep(:rand.uniform(500))
    render conn, "index.html"
  end
end
