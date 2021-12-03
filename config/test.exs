import Config

config :summoner,
  participants_task: Summoner.Participants.FakeParticipantsTask,
  riot_games_requests: Summoner.HTTP.MockRiotGamesRequests
