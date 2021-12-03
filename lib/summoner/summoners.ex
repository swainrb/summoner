defmodule Summoner.Summoners do
  alias Summoner.HTTP.RiotGamesRequests

  def summoner_puuid_from_name(summoner_name) do
    case RiotGamesRequests.impl().get_summoner_by_name(summoner_name) do
      {:ok, %{status: 200} = summoner_response} ->
        {:ok, summoner_response.body.puuid}

      _ ->
        {:error, :user_not_found}
    end
  end
end
