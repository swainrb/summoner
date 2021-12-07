defmodule Summoner.Cache do
  def init_cache() do
    :ets.new(:region, [:set, :named_table, :public])
    :ets.new(:participants, [:set, :named_table, :public])
  end

  def insert_participants(%{} = participants),
    do: Enum.each(participants, &:ets.insert(:participants, &1))

  def insert_region(region), do: :ets.insert(:region, {"region", region})

  def lookup_participants(), do: &:ets.lookup(:participants, &1)

  def lookup_region() do
    [{_, region}] = :ets.lookup(:region, "region")
    region
  end
end
