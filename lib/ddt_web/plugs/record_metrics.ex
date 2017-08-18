defmodule Plugs.RecordMetrics do
  alias Plug.Conn, as: C

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> C.put_private(:plug_record_metrics, %{req_start: DateTime.utc_now})
    |> C.register_before_send(&report_to_statsd/1)
  end

  defp report_to_statsd(conn) do
    req_start = conn.private[:plug_record_metrics][:req_start]
    if req_start do
      DateTime.diff(DateTime.utc_now, req_start, :milliseconds)
      |> ExStatsD.timer("resp_time", tags: ["path:#{conn.request_path}"])
    end
    conn
  end
end
