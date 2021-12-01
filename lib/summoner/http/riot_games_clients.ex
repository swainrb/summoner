defmodule Summoner.HTTP.RiotGamesClients do
  def summoners_client(platform \\ "br1") do
    middleware = [
      {Tesla.Middleware.BaseUrl,
       "https://" <> platform <> ".api.riotgames.com/lol/summoner/v4/summoners"},
      {Tesla.Middleware.JSON, engine_opts: [keys: :atoms]},
      {Tesla.Middleware.Headers, [{"X-Riot-Token", riot_token()}]}
    ]

    Tesla.client(middleware)
  end

  def matches_client(region) do
    middleware = [
      {Tesla.Middleware.BaseUrl,
       "https://" <> region <> ".api.riotgames.com/lol/match/v5/matches"},
      {Tesla.Middleware.JSON, engine_opts: [keys: :atoms]},
      {Tesla.Middleware.Headers, [{"X-Riot-Token", riot_token()}]}
    ]

    Tesla.client(middleware)
  end

  defp riot_token do
    "RGAPI-c61fd297-62c3-4e92-b281-084c7b0aa8b3"
  end
end
