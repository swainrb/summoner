defmodule Summoner.MatchesMonitor do
  use GenServer

  alias Summoner.Cache
  alias Summoner.HTTP.RiotGamesRequests

  def start_link({_summoner_name, _puuid} = init_args) do
    GenServer.start_link(__MODULE__, init_args)
  end

  def init(init_args) do
    {:ok, now} = DateTime.now("Etc/UTC")
    {:ok, Tuple.append(init_args, now)}
  end

  def send_matches_after(pid) do
    Process.send_after(pid, :find_new_matches, match_check_wait_time())
  end

  def handle_info(:find_new_matches, {summoner_name, puuid, last_check_time}) do
    {:ok, now} = DateTime.now("Etc/UTC")

    region = Cache.lookup_region()

    {:ok, response} =
      RiotGamesRequests.get_matches_for_region_by_puuid_from_start_time(
        region,
        puuid,
        last_check_time
      )

    output_matches(summoner_name, response.body)

    {:noreply, {summoner_name, puuid, now}, {:continue, nil}}
  end

  def handle_continue(_continue, state) do
    send_matches_after(self())
    {:noreply, state}
  end

  defp output_matches(summoner_name, matches) do
    Enum.each(matches, fn match ->
      IO.puts("Summoner " <> summoner_name <> " completed match " <> match)
    end)
  end

  defp match_check_wait_time,
    do:
      Application.get_env(
        :summoner,
        :wait_between_grouwait_between_match_checks_in_millisps_in_millis,
        1000 * 60
      )
end
