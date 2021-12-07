defmodule Summoner.SummonersTest do
  use ExUnit.Case, async: true

  import Mox

  alias Summoner.HTTP.MockRiotGamesRequests
  alias Summoner.Summoners

  setup :verify_on_exit!

  describe "summoner_puuid_from_name/2" do
    test "Success: Returns {:ok, account_puiid} when account is found" do
      expect(MockRiotGamesRequests, :get_summoner_by_name, fn sn, _sd ->
        {:ok, %Tesla.Env{status: 200, body: %{puuid: "mock_puuid", name: sn}}}
      end)

      assert Summoners.summoner_puuid_from_name("existing_summoner", "subdomain") ==
               {:ok, {"existing_summoner", "mock_puuid"}}
    end

    test "Fail: Returns {:error, :summoner_not_found} when account is not found" do
      expect(MockRiotGamesRequests, :get_summoner_by_name, fn _sn, _sd ->
        {:ok, %Tesla.Env{status: 404}}
      end)

      assert Summoners.summoner_puuid_from_name("nonexistent_summoner", "subdomain") ==
               {:error, :summoner_not_found}
    end

    test "Fail: Returns {:error, :could_not_get_summoner} for any other HTTP error" do
      expect(MockRiotGamesRequests, :get_summoner_by_name, fn _sn, _sd ->
        {:ok, %Tesla.Env{status: 400}}
      end)

      assert Summoners.summoner_puuid_from_name("existing_summoner", "subdomain") ==
               {:error, :could_not_get_summoner}
    end
  end
end
