defmodule Summoner do
  use GenServer

  alias Summoner.Cache
  alias Summoner.Participants

  def start_link(_) do
    {:ok, pid} = start = GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
    Process.send_after(pid, :kill, kill_time())
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

  defp split_for_rate_limit_delay([]) do
    IO.puts("Monitoring matches")
    :noop
  end

  defp split_for_rate_limit_delay(participants) do
    {take, wait} =
      split =
      participants
      |> Enum.filter(&(elem(&1, 1) != "BOT"))
      |> Enum.split(matches_group_size())

    Enum.each(
      take,
      &DynamicSupervisor.start_child(
        Summoner.MatchesMonitorSupervisor,
        {Summoner.MatchesMonitor, &1}
      )
    )

    :timer.sleep(wait_between_groups())
    split_for_rate_limit_delay(wait)
  end

  defp kill_time,
    do: Application.get_env(:summoner, :application_monitor_time_in_millis, 1000 * 60 * 60)

  defp matches_group_size, do: Application.get_env(:summoner, :matches_per_monitor_group, 10)

  defp wait_between_groups,
    do: Application.get_env(:summoner, :wait_between_groups_in_millis, 5000)
end
