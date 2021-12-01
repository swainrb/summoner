defmodule Summoner.Matches do
  alias Summoner.HTTP.RiotGamesRequests

  def valid_matches_for_puuid_and_region(puuid, region) do
    {:ok, matches_response} = RiotGamesRequests.get_matches_for_region_by_puuid(region, puuid)

    {:ok, matches_response.body}
  end
end
