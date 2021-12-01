defmodule Summoner.UserInput do
  alias Summoner.Regions

  def summoner_name do
    IO.gets("Enter summoner name\n")
    |> String.trim()
  end

  def region do
    IO.gets("Enter region or platform\n")
    |> String.trim()
    |> Regions.region_by_platform_or_region()
  end
end
