defmodule Summoner.UserInputFake do
  alias Summoner.Regions

  def summoner_name do
    "Ýena"
  end

  def region do
    Regions.resolve_region("na")
  end
end
