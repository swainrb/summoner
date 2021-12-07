defmodule Summoner.Summoners do
  alias Summoner.HTTP.RiotGamesRequests

  def summoner_puuid_from_name(summoner_name, subdomain) do
    case RiotGamesRequests.impl().get_summoner_by_name(summoner_name, subdomain) do
      {:ok, %{status: 200} = summoner_response} ->
        {:ok, {summoner_response.body.name, summoner_response.body.puuid}}

      {:ok, %{status: 404}} ->
        {:error, :summoner_not_found}

      _ ->
        {:error, :could_not_get_summoner}
    end
  end
end
