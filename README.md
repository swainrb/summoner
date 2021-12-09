# Summoner

**Reads currently finishing matches for a summoner's recent match participants from the Riot Games API**

## Versions

erlang: 24.1.7

elixir: 1.12.3

## Running

Run with:
```bash
mix run --no-halt
```

Riot games developer key is taken in from system environment variables as `RIOT_GAMES_TOKEN`

Takes input at the console.  The region is taken in as the "platform" and the greater region as well as
subdomains will be resolved from that.

To run with iex you will need to use the `UserInputFake` with the summoner name and platform placed in there 
and swap that module into `user_input_instance()` in `ParticipantsFake`.