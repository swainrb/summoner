defmodule Summoner.Participants.ParticipantsTask do
  use Task

  alias Summoner.{Matches, Summoners}
  alias Summoner.Participants.MatchesParticipants

  def handle_participants do
    with summoner_name <- user_input_instance().summoner_name(),
         {:ok, {region, subdomain}} <- user_input_instance().region(),
         {:ok, {summoner_name_server, puuid}} <-
           Summoners.summoner_puuid_from_name(summoner_name, subdomain),
         {:ok, matches} <- Matches.valid_matches_for_puuid_and_region(puuid, region),
         {:ok, participants} <-
           MatchesParticipants.matches_participants(matches, region) do
      participants = Map.delete(participants, summoner_name_server)
      :ets.insert(:region, {"region", region})
      Enum.each(participants, &:ets.insert(:participants, &1))

      {:ok, Map.keys(participants)}
    else
      _ -> handle_participants()
    end
  end

  def user_input_instance do
    Summoner.UserInput
  end
end
