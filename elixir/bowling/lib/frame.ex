defmodule Frame do
  @enforce_keys [:type, :rolls]
  # @type t :: %__MODULE__{type: :strike | :spare | :normal, rolls: [0..10] | [0..10, 0..10]}
  @type t :: %__MODULE__{type: :strike | :spare | :normal | :fill, rolls: [pos_integer()]}
  defstruct [:type, :rolls]

  def score([]), do: 0
  def score(%Frame{} = frame), do: Enum.reduce(frame.rolls, 0, &Kernel.+/2)
end
