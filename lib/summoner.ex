defmodule Summoner do
  use Task

  alias Summoner.HTTP.RiotGamesRequests
  alias Summoner.Regions

  def start_link(_fun) do
    Task.start_link(&handle_summoners/0)
  end

  def handle_summoners do
    HTTPoison.start()

    # {summoner_name, region} = console_input()

    summoner_name = "blaber"
    region = "americas"

    {:ok, summoner_response} = RiotGamesRequests.get_summoner_by_name(summoner_name)
    summoner_puuid = summoner_response.body.puuid

    {:ok, matches_response} = RiotGamesRequests.get_matches_by_puuid(summoner_puuid, region)

    participants =
      matches_response.body
      |> Task.async_stream(&http_get_match(&1, region))
      |> Enum.reduce(MapSet.new(), fn {:ok, participants}, acc ->
        MapSet.union(acc, participants)
      end)
      |> MapSet.delete(summoner_response.body.puuid)

    participants
    |> IO.inspect()
  end

  defp console_input do
    summoner_name = IO.gets("Enter summoner name\n") |> String.trim()

    {:ok, region} =
      IO.gets("Enter region or platform\n")
      |> String.trim()
      |> Regions.region_by_platform_or_region()

    {summoner_name, region}
  end

  defp http_get_match(match_id, region) do
    {:ok, match_response} = RiotGamesRequests.get_match(match_id, region)

    MapSet.new(match_response.body.metadata.participants)
  end
end
