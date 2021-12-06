defmodule Summoner.Participants do
  use GenServer

  alias Summoner.Participants.TaskSupervisor, as: ParticipantsSupervisor

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  def participants() do
    GenServer.call(__MODULE__, :participants)
  end

  @impl true
  def init(_), do: {:ok, nil}

  @impl true
  def handle_call(:participants, _from, _state) do
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

    {:reply, participants, nil}
  end
end
