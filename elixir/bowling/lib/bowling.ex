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
    |> IO.inspect()
    |> calculate_frames()
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

  def to_frames(rolls) do
    rolls
    |> Enum.zip(1..length(rolls))
    |> Enum.map(&create_frame/1)
  end

  def create_frame({[roll1, roll2], frame_no}) when frame_no > 10,
    do: %Frame{type: :fill, rolls: [roll1, roll2]}

  def create_frame({[roll1, _roll2], _frame_no}) when roll1 == 10,
    do: %Frame{type: :strike, rolls: [10]}

  def create_frame({[roll1, roll2], _frame_no}) when roll1 + roll2 == 10,
    do: %Frame{type: :spare, rolls: [roll1, roll2]}

  def create_frame({[roll1, roll2], _frame_no}),
    do: %Frame{type: :normal, rolls: [roll1, roll2]}

  def calculate_frames(frames) do
    frames
    |> Enum.reduce({[], Enum.drop(frames, 1)}, fn frame, {added_frames, next_frames} ->
      {[calculate_frame(frame, next_frames) | added_frames], Enum.drop(next_frames, 1)}
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  def calculate_frame(%Frame{type: :fill}, _next_frames), do: []

  def calculate_frame(%Frame{type: :strike} = frame, next_frames) do
    next_frames
    |> get_next_rolls(2)
    |> calculate_frame_with_rolls(frame)
  end

  def calculate_frame(%Frame{type: :spare} = frame, next_frames) do
    next_frames
    |> get_next_rolls(1)
    |> calculate_frame_with_rolls(frame)
  end

  def calculate_frame(%Frame{type: :normal} = frame, _next_frames), do: frame

  defp get_next_rolls(frames, number_of_rolls) do
    frames
    |> Enum.take(number_of_rolls)
    |> Enum.reduce([], fn frame, rolls -> rolls ++ frame.rolls end)
    |> Enum.take(number_of_rolls)
  end

  defp calculate_frame_with_rolls(rolls, %Frame{} = frame) do
    %Frame{frame | rolls: frame.rolls ++ rolls}
  end
end
