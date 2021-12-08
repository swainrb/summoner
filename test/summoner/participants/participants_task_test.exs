defmodule Summoner.Participants.ParticipantsTaskTest do
  use ExUnit.Case

  alias Summoner.Participants.ParticipantsTask

  test "Doesn't use UserInputFake" do
    assert ParticipantsTask.user_input_instance() != Summoner.Util.UserInputFake
  end
end
