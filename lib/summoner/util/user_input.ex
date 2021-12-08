defmodule Summoner.Util.UserInput do
  alias Summoner.Util.Regions

  def summoner_name do
    IO.gets("Enter summoner name\n")
    |> String.trim()
  end

  def region do
    IO.gets("Enter region\n")
    |> String.trim()
    |> Regions.resolve_region()
  end
end
