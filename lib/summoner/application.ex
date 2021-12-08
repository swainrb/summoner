defmodule Summoner.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, name: Summoner.Finch},
      Summoner.SummonerSupervisor
    ]

    opts = [strategy: :one_for_one, name: Summoner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
