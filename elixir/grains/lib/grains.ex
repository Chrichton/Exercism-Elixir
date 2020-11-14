defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) when number < 1 or number > 64,
    do: {:error, "The requested square must be between 1 and 64 (inclusive)"}

  def square(number) do
    {:ok, pow_2(number - 1)}
  end

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    number_of_grains =
      1..64
      |> Enum.reduce(0, fn square_no, acc -> acc + pow_2(square_no - 1) end)

    {:ok, number_of_grains}
  end

  def pow_2(exponent), do: pow_2_recursive(exponent, 1)

  def pow_2_recursive(0, accu), do: accu
  def pow_2_recursive(exponent, accu), do: pow_2_recursive(exponent - 1, accu * 2)
end
