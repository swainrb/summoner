defmodule Summoner.Participants.ParticipantsTask do
  use Task

  alias Summoner.{Matches, Participants, Summoners}

  def handle_participants do
    with summoner_name <- user_input_instance().summoner_name(),
         {:ok, puuid} <- Summoners.summoner_puuid_from_name(summoner_name),
         {:ok, region} <- user_input_instance().region(),
         {:ok, matches} <- Matches.valid_matches_for_puuid_and_region(puuid, region),
         {:ok, participants} <-
           Participants.matches_participants(puuid, matches, region) do
      IO.inspect(participants)
      {:ok, Map.keys(participants)}
    else
      _ -> handle_participants()
    end
  end

  def user_input_instance do
    Summoner.UserInputFake
  end
end
