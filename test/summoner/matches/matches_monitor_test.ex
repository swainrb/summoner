defmodule Summoner.Matches.MatchesMonitorTest do
  use ExUnit.Case

  import ExUnit.CaptureLog
  import Mox

  alias Summoner.HTTP.MockRiotGamesRequests
  alias Summoner.Matches.MatchesMonitor
  alias Summoner.Util.{Cache, MockMessages}

  setup :verify_on_exit!

  describe "handle_info/2" do
    test "Success: console receives list of match responses" do
      summoner_name = "summoner_1"
      puuid = "summoner_1_puuid"
      match_id = "match_1"

      expect(
        MockRiotGamesRequests,
        :get_matches_for_region_by_puuid_from_start_to_end_time,
        fn _region, _puuid, _last_check_time, _now ->
          {:ok, %{status: 200, body: [match_id]}}
        end
      )

      expect(MockMessages, :send_to_console, fn msg ->
        assert msg == ["Summoner " <> summoner_name <> " completed match " <> match_id]
      end)

      start_supervised!({MatchesMonitor, {10_000_000, {summoner_name, puuid}}})

      Cache.insert_region("na")
      {:ok, now} = DateTime.now("Etc/UTC")
      MatchesMonitor.handle_info(:find_new_matches, {summoner_name, puuid, now})
    end

    test "Failure: logs rate limiting" do
      summoner_name = "summoner_1"
      puuid = "summoner_1_puuid"

      expect(
        MockRiotGamesRequests,
        :get_matches_for_region_by_puuid_from_start_to_end_time,
        fn _region, _puuid, _last_check_time, _now ->
          {:ok, %{status: 429}}
        end
      )

      start_supervised!({MatchesMonitor, {10_000_000, {summoner_name, puuid}}})

      Cache.insert_region("na")
      {:ok, now} = DateTime.now("Etc/UTC")

      assert capture_log(fn ->
               MatchesMonitor.handle_info(:find_new_matches, {summoner_name, puuid, now})
             end) =~ "Rate limited for match check."
    end
  end
end
