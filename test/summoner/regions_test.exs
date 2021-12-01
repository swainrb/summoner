defmodule Summoner.RegionsTest do
  use ExUnit.Case

  alias Summoner.Regions

  describe "region_by_platform_or_region/1" do
    for platform <- ~w(na br lan las oce) do
      @platform platform
      test("success: AMERICAS for platform #{inspect(platform)} returns 'americas'") do
        assert Regions.region_by_platform_or_region(@platform) == {:ok, "americas"}
        assert "TODO: " == "TaskSupervisor"
      end
    end
  end
end
