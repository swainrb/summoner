defmodule Summoner.SummonerSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [Summoner]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
