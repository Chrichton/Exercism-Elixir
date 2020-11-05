defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """

  defstruct direction: :north, position: {0, 0}

  @valid_directions [:north, :east, :south, :west]

  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, {x, y} = position)
      when direction in @valid_directions and is_integer(x) and is_integer(y),
      do: %RobotSimulator{direction: direction, position: position}

  def create(direction, _) when direction in @valid_directions,
    do: {:error, "invalid position"}

  def create(_, _), do: {:error, "invalid direction"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.codepoints()
    |> Enum.reduce(robot, fn character, acc ->
      if acc == {:error, "invalid instruction"},
        do: acc,
        else: execute_command(acc, character)
    end)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.position
  end

  defp execute_command(robot, character) do
    case character do
      "R" -> turn_right(robot)
      "A" -> advance(robot)
      "L" -> turn_left(robot)
      _ -> {:error, "invalid instruction"}
    end
  end

  defp turn_right(robot) do
    case robot.direction do
      :north -> %RobotSimulator{robot | direction: :east}
      :east -> %RobotSimulator{robot | direction: :south}
      :south -> %RobotSimulator{robot | direction: :west}
      :west -> %RobotSimulator{robot | direction: :north}
    end
  end

  defp turn_left(robot) do
    case robot.direction do
      :north -> %RobotSimulator{robot | direction: :west}
      :east -> %RobotSimulator{robot | direction: :north}
      :south -> %RobotSimulator{robot | direction: :east}
      :west -> %RobotSimulator{robot | direction: :south}
    end
  end

  defp advance(robot) do
    {x, y} = robot.position

    case robot.direction do
      :north -> %RobotSimulator{robot | position: {x, y + 1}}
      :east -> %RobotSimulator{robot | position: {x + 1, y}}
      :south -> %RobotSimulator{robot | position: {x, y - 1}}
      :west -> %RobotSimulator{robot | position: {x - 1, y}}
    end
  end
end
