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

    {:ok, participants} = Task.await(task)

    {:ok, IO.inspect(participants)}
  end
end
