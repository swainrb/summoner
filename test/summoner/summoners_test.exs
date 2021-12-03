defmodule Summoner.SummonersTest do
  use ExUnit.Case, async: true

  import Mox

  alias Summoner.HTTP.MockRiotGamesRequests
  alias Summoner.Summoners

  setup :verify_on_exit!

  describe "summoner_puuid_from_name/1" do
    test "Success: Returns {:ok, account_puiid} when account is found" do
      expect(MockRiotGamesRequests, :get_summoner_by_name, fn _sn ->
        {:ok, %Tesla.Env{status: 200, body: %{puuid: "mock_puuid"}}}
      end)

      assert Summoners.summoner_puuid_from_name("existing_summoner") == {:ok, "mock_puuid"}
    end
  end
end

{:ok,
 %Tesla.Env{
   __client__: %Tesla.Client{
     adapter: nil,
     fun: nil,
     post: [],
     pre: [
       {Tesla.Middleware.BaseUrl, :call,
        ["https://br1.api.riotgames.com/lol/summoner/v4/summoners"]},
       {Tesla.Middleware.JSON, :call, [[engine_opts: [keys: :atoms]]]},
       {Tesla.Middleware.Headers, :call,
        [[{"X-Riot-Token", "RGAPI-c61fd297-62c3-4e92-b281-084c7b0aa8b3"}]]}
     ]
   },
   __module__: Tesla,
   body: %{status: %{message: "Forbidden", status_code: 403}},
   headers: [
     {"connection", "keep-alive"},
     {"date", "Fri, 03 Dec 2021 19:50:24 GMT"},
     {"content-length", "52"},
     {"content-type", "application/json;charset=utf-8"},
     {"x-riot-edge-trace-id", "e255803b-e368-4179-a7e9-ad5b8943c5ee"}
   ],
   method: :get,
   opts: [],
   query: [],
   status: 403,
   url: "https://br1.api.riotgames.com/lol/summoner/v4/summoners/by-name/blaber"
 }}
