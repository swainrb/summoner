defmodule Summoner do
  use Task

  alias Summoner.{Matches, Participants, Summoners, UserInput}

  def start_link(_fun) do
    Task.start_link(&handle_summoner/0)
  end

  def handle_summoner do
    with summoner_name <- UserInput.summoner_name(),
         {:ok, puuid} <- Summoners.summoner_puuid_from_name(summoner_name),
         {:ok, region} <- UserInput.region(),
         {:ok, matches} <- Matches.valid_matches_for_puuid_and_region(puuid, region),
         {:ok, participants} <- Participants.matches_participants(puuid, matches, region) do
      IO.inspect(participants)
    else
      _ -> handle_summoner()
    end
  end
end
