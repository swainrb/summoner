import Config

config :summoner,
  riot_token: "RGAPI-b0695bf0-02a6-46e4-9380-843721785b55",
  application_monitor_time_in_millis: 1000 * 60 * 60,
  match_count_to_get_participants_from: 5,
  matches_per_monitor_group: 5,
  wait_between_groups_in_millis: 2000,
  wait_between_match_checks_in_millis: 1000 * 60 + 1000

config :logger, :console, format: "$time $metadata[$level] $message\n"

config :tesla, adapter: Tesla.Adapter.Hackney

import_config "#{config_env()}.exs"
