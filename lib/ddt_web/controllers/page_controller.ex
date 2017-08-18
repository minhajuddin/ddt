defmodule DdtWeb.PageController do
  use DdtWeb, :controller

  plug Plugs.RecordMetrics

  def index(conn, _params) do
    req_id = conn |> get_request_id

    MetricAggregator.record(req_id, :action)

    :timer.sleep(:rand.uniform(500))
    MetricAggregator.record(req_id, :redis_read, %{results: :rand.uniform(300)})

    :timer.sleep(:rand.uniform(500))
    MetricAggregator.record(req_id, :soft_return)

    render conn, "index.html"
  end

  require Logger
  @request_id_header "x-request-id"
  defp get_request_id(conn) do
    case Plug.Conn.get_resp_header(conn, @request_id_header) do
      [req_id | _] -> req_id
      [] -> Logger.error("No request ID")
    end
  end

end
