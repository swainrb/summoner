defmodule Summoner.Messages do
  use GenServer

  require Logger

  def start_link(_), do: GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)

  @impl true
  def init(_), do: {:ok, nil}

  def process_message(msg) do
    Process.send(__MODULE__, msg, [])
  end

  @impl true
  def handle_info({summoner_name, %{status: 200, body: matches}}, state) do
    Enum.each(matches, fn match ->
      IO.puts("Summoner " <> summoner_name <> " completed match " <> match)
    end)

    {:noreply, state}
  end

  def handle_info({summoner_name, %{status: 429}}, state) do
    Logger.error("Rate limited for match check. Summoner: #{summoner_name}")

    {:noreply, state}
  end
end
