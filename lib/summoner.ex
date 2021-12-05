defmodule Summoner do
  use GenServer

  alias Summoner.Participants.TaskSupervisor, as: ParticipantsSupervisor

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  def init(_) do
    summoner =
      Application.get_env(:summoner, :participants_task, Summoner.Participants.ParticipantsTask)

    task =
      Task.Supervisor.async(
        ParticipantsSupervisor,
        summoner,
        :handle_participants,
        []
      )

    :ets.new(:participants, [:set, :named_table, :public])

    {:ok, participants} = Task.await(task)

    participants_from_cache =
      Enum.map(participants, &:ets.lookup(:participants, &1))
      |> IO.inspect()

    {:ok, participants}
  end
end
