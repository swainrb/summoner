defmodule Summoner.RegionsTest do
  use ExUnit.Case

  alias Summoner.Regions

  describe "region_by_platform_or_region/1" do
    for platform <- ~w(na br lan las oce) do
      @platform platform
      test "success: North American platform names #{inspect(platform)} returns 'americas'" do
        assert Regions.region_by_platform_or_region(@platform) == {:ok, "americas"}
      end
    end

    test "success: 'AMERICAS' region returns americas" do
      assert Regions.region_by_platform_or_region("AMERICAS") == {:ok, "americas"}
    end

    for platform <- ~w(kr jp) do
      @platform platform
      test "success: Asian platform names #{inspect(platform)} returns 'asia'" do
        assert Regions.region_by_platform_or_region(@platform) == {:ok, "asia"}
      end
    end

    test "success: 'ASIA' region returns americas" do
      assert Regions.region_by_platform_or_region("ASIA") == {:ok, "asia"}
    end

    for platform <- ~w(eune euw tr ru) do
      @platform platform
      test "success: European platform names #{inspect(platform)} returns 'europe'" do
        assert Regions.region_by_platform_or_region(@platform) == {:ok, "europe"}
      end
    end

    test "success: 'EUROPE' region returns americas" do
      assert Regions.region_by_platform_or_region("EUROPE") == {:ok, "europe"}
    end
  end
end
