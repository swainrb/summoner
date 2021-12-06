defmodule Summoner.MatchesMonitor do
  use GenServer

  def start_link({_summoner_name, _puuid} = init_args) do
    {:ok, pid} = start = GenServer.start_link(__MODULE__, init_args)
    send_matches_after(pid)
    start
  end

  def init(init_args) do
    {:ok, init_args}
  end

  def send_matches_after(pid) do
    Process.send_after(pid, :find_new_matches, wait_time())
  end

  def handle_info(:find_new_matches, {summoner_name, puuid} = state) do
    {:ok, now} = DateTime.now("Etc/UTC")
    now_iso = DateTime.to_iso8601(now)

    IO.puts(now_iso <> " - " <> summoner_name <> ": " <> puuid)
    send_matches_after(self())
    {:noreply, state}
  end

  defp wait_time() do
    1000
  end
end
