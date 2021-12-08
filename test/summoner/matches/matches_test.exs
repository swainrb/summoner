defmodule Summoner.MatchesTest do
  use ExUnit.Case, async: true

  import Mox

  alias Summoner.HTTP.MockRiotGamesRequests
  alias Summoner.Matches

  setup :verify_on_exit!

  describe "get_matches_for_region_by_puuid/2" do
    test "Success: Returns {:ok, account_puiid} when account is found" do
      expect(MockRiotGamesRequests, :get_matches_for_region_by_puuid, fn _region, _puuid ->
        {:ok, %Tesla.Env{status: 200, body: ["summoner_1", "summoner_2"]}}
      end)

      assert Matches.valid_matches_for_puuid_and_region("na", "summoner_puuid") ==
               {:ok, ["summoner_1", "summoner_2"]}
    end

    test "Fail: Returns {:error, :could_not_get_summoner} for any other HTTP error" do
      expect(MockRiotGamesRequests, :get_matches_for_region_by_puuid, fn _region, _puuid ->
        {:ok, %Tesla.Env{status: 400}}
      end)

      assert Matches.valid_matches_for_puuid_and_region("na", "summoner_puuid") ==
               {:error, :could_not_get_matches}
    end
  end
end
