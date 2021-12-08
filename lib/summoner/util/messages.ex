defmodule Summoner.Util.Messages do
  def send_to_console(msgs) when is_list(msgs), do: Enum.each(msgs, &send_to_console(&1))
  def send_to_console(msg), do: IO.puts(msg)
end
