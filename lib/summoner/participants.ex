defmodule Summoner.Participants do
  alias Summoner.HTTP.RiotGamesRequests

  def matches_participants(puuid, matches, region) do
    participants =
      matches
      |> Task.async_stream(&http_get_match(&1, region))
      |> Enum.reduce(MapSet.new(), fn {:ok, participants}, acc ->
        MapSet.union(acc, participants)
      end)
      |> MapSet.delete(puuid)

    {:ok, participants}
  end

  defp http_get_match(match_id, region) do
    {:ok, match_response} = RiotGamesRequests.get_match(match_id, region)

    MapSet.new(match_response.body.metadata.participants)
  end
end
