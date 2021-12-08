defmodule Summoner do
  use GenServer

  alias Summoner.Util.Cache
  alias Summoner.Participants

  def start_link(_) do
    {:ok, pid} = start = GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
    Process.send_after(pid, :kill_application, kill_time())
    monitor_matches()
    start
  end

  @impl true
  def init(_) do
    Cache.init_cache()
    participants = Participants.participants()

    {:ok, participants}
  end

  def monitor_matches(), do: GenServer.cast(__MODULE__, :monitor_matches)

  @impl true
  def handle_cast(:monitor_matches, state) do
    Enum.map(state, Cache.lookup_participants())
    |> List.flatten()
    |> split_for_rate_limit_delay()

    {:noreply, state}
  end

  @impl true
  def handle_info(:kill_application, _state) do
    System.stop()
  end

  defp split_for_rate_limit_delay([]), do: nil

  defp split_for_rate_limit_delay(participants) do
    participants = Enum.filter(participants, &(elem(&1, 1) != "BOT"))

    single_check_delay = match_check_wait_time() / Enum.count(participants)

    for n <- 0..(Enum.count(participants) - 1) do
      (single_check_delay * n)
      |> round()
    end
    |> Enum.zip(participants)
    |> Task.async_stream(
      &DynamicSupervisor.start_child(
        Summoner.Matches.MatchesMonitorSupervisor,
        {Summoner.Matches.MatchesMonitor, &1}
      )
    )
    |> Stream.run()

    IO.puts("Monitoring matches")
  end

  defp match_check_wait_time,
    do:
      Application.get_env(
        :summoner,
        :wait_between_match_checks_in_millis,
        1000 * 60
      )

  defp kill_time,
    do: Application.get_env(:summoner, :application_monitor_time_in_millis, 1000 * 60 * 60)
end
