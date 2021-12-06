defmodule Summoner do
  use GenServer

  alias Summoner.Participants

  def start_link(_) do
    start = GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
    monitor_matches()
    start
  end

  def init(_) do
    :ets.new(:participants, [:set, :named_table, :public])

    participants = Participants.participants()

    {:ok, participants}
  end

  def monitor_matches() do
    GenServer.cast(__MODULE__, :monitor_matches)
  end

  def handle_cast(:monitor_matches, state) do
    Enum.map(state, &:ets.lookup(:participants, &1))
    |> IO.inspect()

    {:noreply, state}
  end
end
