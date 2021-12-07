defmodule Summoner.Matches do
  alias Summoner.HTTP.RiotGamesRequests

  def valid_matches_for_puuid_and_region(puuid, region) do
    case RiotGamesRequests.impl().get_matches_for_region_by_puuid(region, puuid) do
      {:ok, %{status: 200} = matches_response} ->
        {:ok, matches_response.body}

      _ ->
        {:error, :could_not_get_matches}
    end
  end
end
