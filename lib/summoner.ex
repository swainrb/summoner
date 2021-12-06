defmodule Summoner do
  use GenServer

  alias Summoner.Participants

  def start_link(_) do
    {:ok, pid} = start = GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
    monitor_matches()
    Process.send_after(pid, :kill, kill_time())
    start
  end

  def init(_) do
    :ets.new(:participants, [:set, :named_table, :public])

    participants = Participants.participants()

    {:ok, participants}
  end

  def monitor_matches(), do: GenServer.cast(__MODULE__, :monitor_matches)

  def handle_cast(:monitor_matches, state) do
    Enum.map(state, &:ets.lookup(:participants, &1))
    |> List.flatten()
    |> Enum.each(
      &DynamicSupervisor.start_child(
        Summoner.MatchesMonitorSupervisor,
        {Summoner.MatchesMonitor, &1}
      )
    )

    {:noreply, state}
  end

  def handle_info(:kill, _state) do
    IO.puts("Terminating")
    System.stop()
  end

  defp kill_time() do
    3000
  end
end
