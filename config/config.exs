import Config

config :summoner,
  riot_token: "RGAPI-b1cfb81f-8037-43c3-a0e8-3f32383b0f88",
  application_monitor_time_in_millis: 1000 * 60 * 60,
  match_count_to_get_participants_from: 5,
  wait_between_match_checks_in_millis: 60_000

config :logger, :console, format: "$time $metadata[$level] $message\n"

config :tesla, :adapter, {Tesla.Adapter.Finch, name: Summoner.Finch}

import_config "#{config_env()}.exs"
