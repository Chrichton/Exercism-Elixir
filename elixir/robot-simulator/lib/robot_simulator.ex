defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """

  @valid_directions [:north, :east, :south, :west]

  defmodule Robot do
    defstruct [:direction, :position]

    @type direction :: {:north | :east | :south | :west}

    @type t :: %__MODULE__{
            direction: direction(),
            position: {integer(), integer()}
          }
  end

  # @spec create(direction :: Robot.direction(), position :: {integer, integer):: Robot.t() | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, {x, y} = position)
      when direction in @valid_directions and is_integer(x) and is_integer(y),
      do: %Robot{direction: direction, position: position}

  def create(direction, _) when direction in @valid_directions,
    do: {:error, "invalid position"}

  def create(_, _), do: {:error, "invalid direction"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: Robot.t(), instructions :: String.t()) :: Robot.t()
  def simulate(robot = %Robot{}, instructions) do
    instructions
    |> String.codepoints()
    |> Enum.reduce_while(robot, &execute_command(&2, &1))
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: Robot.t()) :: Robot.direction()
  def direction(robot = %Robot{}) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: Robot.t()) :: {integer, integer}
  def position(robot = %Robot{}) do
    robot.position
  end

  defp execute_command(robot = %Robot{}, character) do
    case character do
      "R" -> {:cont, turn_right(robot)}
      "A" -> {:cont, advance(robot)}
      "L" -> {:cont, turn_left(robot)}
      _ -> {:halt, {:error, "invalid instruction"}}
    end
  end

  defp turn_right(robot = %Robot{direction: d}) do
    %Robot{robot | direction: right(d)}
  end

  defp right(:north), do: :east
  defp right(:east), do: :south
  defp right(:south), do: :west
  defp right(:west), do: :north

  defp turn_left(robot = %Robot{direction: d}) do
    %Robot{robot | direction: left(d)}
  end

  defp left(:north), do: :west
  defp left(:east), do: :north
  defp left(:south), do: :east
  defp left(:west), do: :south

  defp advance(robot = %Robot{}) do
    {x, y} = robot.position

    case robot.direction do
      :north -> %Robot{robot | position: {x, y + 1}}
      :east -> %Robot{robot | position: {x + 1, y}}
      :south -> %Robot{robot | position: {x, y - 1}}
      :west -> %Robot{robot | position: {x - 1, y}}
    end
  end
end
