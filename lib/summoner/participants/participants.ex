defmodule Summoner.Participants do
  alias Summoner.HTTP.RiotGamesRequests

  def matches_participants(puuid, matches, region) do
    participants =
      matches
      |> Task.async_stream(&http_get_match(&1, region))
      |> Enum.reduce(%{}, fn {:ok, x}, acc -> Map.merge(acc, x) end)

    {:ok, participants}
  end

  defp http_get_match(match_id, region) do
    {:ok, match_response} = RiotGamesRequests.impl().get_match(match_id, region)

    match_response.body.info.participants
    |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x.summonerName, x.puuid) end)
  end
end
