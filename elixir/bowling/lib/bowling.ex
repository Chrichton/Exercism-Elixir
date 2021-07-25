defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  use Agent

  alias __MODULE__

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
    |> expand_strikes()
    |> Enum.chunk_every(2)
    |> to_frames()
    |> Enum.reduce(0, fn frame, acc -> acc + Frame.score(frame) end)
  end

  def expand_strikes(rolls) do
    rolls
    |> Enum.reduce([], fn roll, acc ->
      if roll == 10,
        do: [0 | [10 | acc]],
        else: [roll | acc]
    end)
    |> Enum.reverse()
  end

  def to_frames(rolls),
    do: Enum.map(rolls, &create_frame/1)

  def create_frame([roll1, _roll2]) when roll1 == 10,
    do: %Frame{type: :strike, rolls: [10]}

  def create_frame([roll1, roll2]) when roll1 + roll2 == 10,
    do: %Frame{type: :spare, rolls: [roll1, roll2]}

  def create_frame([roll1, roll2]),
    do: %Frame{type: :normal, rolls: [roll1, roll2]}
end
