defmodule Summoner.HTTP.RiotGamesRequests do
  alias Summoner.HTTP.RiotGamesClients

  def get_summoner_by_name(summoner_name) do
    client = RiotGamesClients.summoners_client()

    case Tesla.get(client, "/by-name/" <> summoner_name) do
      {:ok, %{status: 200} = response} -> {:ok, response}
      _ -> :error
    end
  end

  def get_matches_for_region_by_puuid(region, puuid) do
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
