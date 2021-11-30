defmodule Summoner.HTTP.RiotGamesRequests do
  alias Summoner.HTTP.RiotGamesClients

  def get_summoner_by_name(summoner_name) do
    RiotGamesClients.summoners_client()
    |> Tesla.get("/by-name/" <> summoner_name)
  end

  def get_matches_by_puuid(puuid, region) do
    region
    |> RiotGamesClients.matches_client()
    |> Tesla.get(
      "/by-puuid/" <>
        puuid <>
        "/ids?start=" <> get_match_start_index() <> "&count=" <> get_match_count()
    )
  end

  def get_match(match_id, region) do
    region
    |> RiotGamesClients.matches_client()
    |> Tesla.get("/" <> match_id)
  end

  defp get_match_start_index do
    Integer.to_string(0)
  end

  defp get_match_count do
    Integer.to_string(5)
  end
end
