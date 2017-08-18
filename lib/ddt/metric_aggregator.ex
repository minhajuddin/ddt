defmodule MetricAggregator do
  @behaviour GenServer
  use GenServer
  require Logger

  @metrics_tab :metrics_tab

  # TODO: wrap this module in a try catch, so it never fails

  ## client api ####################
  def start_recording(request_id), do: record(request_id, :start)

  def record(request_id, event, meta \\ %{})
  when is_binary(request_id) and is_atom(event) do
    metrics = case :ets.lookup(@metrics_tab, request_id) do
      [{_, metrics}] -> metrics
      _ -> %{}
    end

    metrics = Map.put(metrics, event, {DateTime.utc_now, meta})
    :ets.insert(@metrics_tab, {request_id, metrics})
  end

  def aggregate_and_report(request_id) do
    case :ets.lookup(@metrics_tab, request_id) do
      [{_, %{start: {start_dt, _}} = metrics}] ->
        metrics
        |> Map.delete(:start) # filter out start event
        |> Enum.each(fn {event, {event_dt, event_meta}}->
          DateTime.diff(event_dt, start_dt, :milliseconds)
          |> ExStatsD.timer(to_string(event), tags: meta_to_tags(event_meta))
        end)
      _ ->
        Logger.warn("missing metrics or recording not started")
    end
  end

  defp meta_to_tags(%{} = meta), do: Enum.map(meta, fn {k,v} -> "#{k}=#{v}" end)

  ## server callbacks ##############
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    :ets.new(@metrics_tab, [:named_table, {:write_concurrency, true}, {:read_concurrency, true}, :public])
    {:ok, state}
  end
end
