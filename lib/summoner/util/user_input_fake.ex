defmodule Summoner.Util.UserInputFake do
  alias Summoner.Util.Regions

  def summoner_name do
    "Puddi Puddi"
  end

  def region do
    Regions.resolve_region("na")
  end
end
