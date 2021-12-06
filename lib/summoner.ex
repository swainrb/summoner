defmodule Summoner do
  use GenServer

  alias Summoner.Participants

  def start_link(_) do
    {:ok, pid} = start = GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
    Process.send_after(pid, :kill, kill_time())
    monitor_matches()
    start
  end

  def init(_) do
    :ets.new(:region, [:set, :named_table, :public])
    :ets.new(:participants, [:set, :named_table, :public])

    participants = Participants.participants()

    {:ok, participants}
  end

  def monitor_matches(), do: GenServer.cast(__MODULE__, :monitor_matches)

  def handle_cast(:monitor_matches, state) do
    Enum.map(state, &:ets.lookup(:participants, &1))
    |> List.flatten()
    |> split_for_rate_limit_delay()

    [{_, region}] = :ets.lookup(:region, "region")
    IO.inspect(region)

    {:noreply, state}
  end

  def handle_info(:kill, _state) do
    IO.puts("Terminating")
    System.stop()
  end

  defp split_for_rate_limit_delay([]) do
    :noop
  end

  defp split_for_rate_limit_delay(participants) do
    {take, wait} = Enum.split(participants, 10)

    Enum.each(
      take,
      &DynamicSupervisor.start_child(
        Summoner.MatchesMonitorSupervisor,
        {Summoner.MatchesMonitor, &1}
      )
    )

    :timer.sleep(1000)
    split_for_rate_limit_delay(wait)
  end

  defp kill_time() do
    130_000
  end
end
