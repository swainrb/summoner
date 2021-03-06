defmodule Summoner.HTTP.RiotGamesClients do
  def summoners_client(subdomain) do
    middleware = [
      {Tesla.Middleware.BaseUrl,
       "https://" <> subdomain <> ".api.riotgames.com/lol/summoner/v4/summoners"},
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

  defp riot_token, do: Application.get_env(:summoner, :riot_token)
end
