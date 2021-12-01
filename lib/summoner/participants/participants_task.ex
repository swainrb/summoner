defmodule Summoner.ParticipantsTask do
  use Task

  alias Summoner.{Matches, Participants, Summoners, UserInput}

  def handle_participants do
    with summoner_name <- UserInput.summoner_name(),
         {:ok, puuid} <- Summoners.summoner_puuid_from_name(summoner_name),
         {:ok, region} <- UserInput.region(),
         {:ok, matches} <- Matches.valid_matches_for_puuid_and_region(puuid, region),
         {:ok, participants} <- Participants.matches_participants(puuid, matches, region) do
      participants =
        participants
        |> MapSet.to_list()
        |> IO.inspect()

      {:ok, participants}
    else
      _ -> handle_participants()
    end
  end
end
