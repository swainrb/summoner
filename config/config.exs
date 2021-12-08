import Config

config :summoner,
  riot_token: System.get_env("RIOT_GAMES_TOKEN"),
  application_monitor_time_in_millis: 1000 * 60 * 60,
  match_count_to_get_participants_from: 5,
  wait_between_match_checks_in_millis: 60_000

config :logger, :console, format: "$time $metadata[$level] $message\n"

config :tesla, :adapter, {Tesla.Adapter.Finch, name: Summoner.Finch}

import_config "#{config_env()}.exs"
