defmodule Plugs.RecordMetrics do
  require Logger

  alias Plug.Conn, as: C
  @behaviour Plug

  def init(opts), do: opts

  @request_id_header "x-request-id"
  def call(conn, _opts) do
    conn
    |> get_request_id
    |> MetricAggregator.start_recording

    conn
    |> C.register_before_send(&report_to_statsd/1)
  end

  defp report_to_statsd(conn) do
    request_id = get_request_id conn
    MetricAggregator.record request_id, :resp_time
    MetricAggregator.aggregate_and_report request_id
    conn
  end

  defp get_request_id(conn) do
    case C.get_resp_header(conn, @request_id_header) do
      [req_id | _] -> req_id
      [] -> Logger.error("No request ID")
    end
  end
end
