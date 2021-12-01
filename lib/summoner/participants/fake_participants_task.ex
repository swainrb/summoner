defmodule Summoner.FakeParticipantsTask do
  @moduledoc """
  Fakes the user input loop that loads as a task in the application supervisor.
  This will avoid having that loop run during tests.

  In general, putting code that should not be run in production here is a bad
  practice but this being the entry point into the app it is very hard to avoid.
  I believe confining the injection point to the test.exs config file is a good
  compromise in this case.

  This is only necessary because input and output is done at in the consul and
  so noise is reduced during testing.
  """

  use Task

  def start_link(_fun) do
    Task.start_link(&handle_participants/0)
  end

  def handle_participants do
    []
  end
end
