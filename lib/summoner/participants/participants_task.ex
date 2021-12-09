defmodule Summoner.Participants.ParticipantsTask do
  use Task

  alias Summoner.{Matches, Summoners}
  alias Summoner.Participants.MatchesParticipants
  alias Summoner.Util.Cache

  def handle_participants do
    with summoner_name <- user_input_instance().summoner_name(),
         {:ok, {region, subdomain}} <- user_input_instance().region(),
         {:ok, {summoner_name_server, puuid}} <-
           Summoners.summoner_puuid_from_name(summoner_name, subdomain),
         {:ok, matches} <- Matches.valid_matches_for_puuid_and_region(puuid, region),
         {:ok, participants} <-
           MatchesParticipants.matches_participants(matches, region) do
      participants = Map.delete(participants, summoner_name_server)

      Cache.insert_region(region)
      Cache.insert_participants(participants)

      {:ok, Map.keys(participants)}
    else
      {:error, :summoner_not_found} ->
        IO.puts("Could not find summoner")
        handle_participants()

      {:error, :could_not_get_summoner} ->
        IO.puts("Error getting summoner")
        handle_participants()

      {:error, :unknown_region} ->
        IO.puts("Unknown region")
        handle_participants()

      {:error, :could_not_get_matches} ->
        IO.puts("Could not get matchs")
        handle_participants()
    end
  end

  def user_input_instance do
    Summoner.Util.UserInput
  end
end
