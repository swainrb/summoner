defmodule Summoner.HTTP.RiotGamesRequests do
  alias Summoner.HTTP.RiotGamesClients

  @callback get_summoner_by_name(String.t(), String.t()) :: {:ok, %Tesla.Env{}}

  @callback get_matches_for_region_by_puuid(String.t(), String.t()) :: {:ok, %Tesla.Env{}}

  @callback get_match(String.t(), String.t()) :: {:ok, %Tesla.Env{}}

  def get_summoner_by_name(summoner_name, subdomain) do
    summoner_name = String.replace(summoner_name, " ", "")

    RiotGamesClients.summoners_client(subdomain)
    |> Tesla.get("/by-name/" <> summoner_name)
  end

  def get_matches_for_region_by_puuid(region, puuid) do
    region
    |> RiotGamesClients.matches_client()
    |> Tesla.get(
      "/by-puuid/" <>
        puuid <>
        "/ids?" <> "&count=" <> match_count()
    )
  end

  def get_matches_for_region_by_puuid_from_start_time(region, puuid, start_time) do
    region
    |> Summoner.HTTP.RiotGamesClients.matches_client()
    |> Tesla.get(
      "/by-puuid/" <>
        puuid <>
        "/ids?" <> "&count=5&startTime=" <> Integer.to_string(DateTime.to_unix(start_time))
    )
  end

  def get_match(match_id, region) do
    region
    |> RiotGamesClients.matches_client()
    |> Tesla.get("/" <> match_id)
  end

  def impl, do: Application.get_env(:summoner, :riot_games_requests, __MODULE__)

  defp match_count do
    Application.get_env(:summoner, :match_count_to_get_participants_from, 5)
    |> Integer.to_string(5)
  end
end
