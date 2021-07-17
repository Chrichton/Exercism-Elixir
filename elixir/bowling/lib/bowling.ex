defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  use Agent

  @spec start() :: any
  def start do
    {:ok, game} = Agent.start_link(fn -> [] end, name: __MODULE__)
    game
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()
  def roll(game, roll) do
    Agent.update(game, fn state -> [roll | state] end)
    game
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  # result = Agent.get(__MODULE__, fn state -> state end)
  # IO.inspect(result)

  def score(game) do
    Agent.get(game, fn state -> state end)
    |> Enum.reverse()
    |> Enum.reduce(0, fn roll, acc -> acc + roll end)
  end
end
