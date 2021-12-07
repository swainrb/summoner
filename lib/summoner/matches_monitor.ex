defmodule Summoner.MatchesMonitor do
  use GenServer

  def start_link({_summoner_name, _puuid} = init_args) do
    {:ok, pid} = start = GenServer.start_link(__MODULE__, init_args)
    Process.send(pid, :find_new_matches, [])
    start
  end

  def init(init_args) do
    {:ok, now} = DateTime.now("Etc/UTC")
    {:ok, Tuple.append(init_args, now)}
  end

  def send_matches_after(pid) do
    Process.send_after(pid, :find_new_matches, wait_time())
  end

  def handle_info(:find_new_matches, {summoner_name, puuid, last_check_time}) do
    {:ok, now} = DateTime.now("Etc/UTC")

    {:ok, response} = get_matches_for_region_by_puuid(puuid, last_check_time)
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

  defp wait_time() do
    60000
  end

  def get_matches_for_region_by_puuid(puuid, start_time) do
    [{_, region}] = :ets.lookup(:region, "region")

    region
    |> Summoner.HTTP.RiotGamesClients.matches_client()
    |> Tesla.get(
      "/by-puuid/" <>
        puuid <>
        "/ids?" <> "&count=5&startTime=" <> Integer.to_string(DateTime.to_unix(start_time))
    )
  end
end
