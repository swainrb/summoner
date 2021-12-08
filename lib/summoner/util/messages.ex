defmodule Summoner.Util.Messages do
  @callback send_to_console([String.t()] | String.t()) :: :ok

  def send_to_console(msgs) when is_list(msgs), do: Enum.each(msgs, &send_to_console(&1))
  def send_to_console(msg), do: IO.puts(msg)

  def impl, do: Application.get_env(:summoner, :messages_module, __MODULE__)
end
