defmodule Summoner.Matches.MatchesMonitor do
  use GenServer

  require Logger

  alias Summoner.Util.{Cache, Messages}
  alias Summoner.HTTP.RiotGamesRequests

  def start_link({initial_delay, {_summoner_name, _puuid} = init_args}) do
    {:ok, pid} = start = GenServer.start_link(__MODULE__, init_args)
    send_matches_after(pid, initial_delay)
    start
  end

  @impl true
  def init(init_args) do
    {:ok, now} = DateTime.now("Etc/UTC")
    {:ok, Tuple.append(init_args, now)}
  end

  def send_matches_after(pid, delay) do
    Process.send_after(pid, :find_new_matches, delay)
  end

  @impl true
  def handle_info(:find_new_matches, {summoner_name, puuid, last_check_time}) do
    {:ok, now} = DateTime.now("Etc/UTC")
    send_matches_after(self(), match_check_wait_time())

    region = Cache.lookup_region()

    {:ok, response} =
      RiotGamesRequests.impl().get_matches_for_region_by_puuid_from_start_to_end_time(
        region,
        puuid,
        last_check_time,
        now
      )

    handle_result(summoner_name, response)

    {:noreply, {summoner_name, puuid, now}}
  end

  defp handle_result(summoner_name, %{status: 200, body: matches}) do
    matches
    |> Enum.map(&("Summoner " <> summoner_name <> " completed match " <> &1))
    |> Messages.impl().send_to_console()
  end

  defp handle_result(_summoner_name, %{status: 429}) do
    Logger.error("Rate limited for match check.")
  end

  defp match_check_wait_time,
    do:
      Application.get_env(
        :summoner,
        :wait_between_match_checks_in_millis,
        1000 * 60
      )
end
