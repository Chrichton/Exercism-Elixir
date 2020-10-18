defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    number_to_binary(code)
    |> Enum.reverse()
    |> Enum.zip(["wink", "double blink", "close your eyes", "jump", "reverse"])
    |> Enum.reduce([], fn {bit, text}, acc ->
      if bit == 1 do
        if text == "reverse" do
          Enum.reverse(acc)
        else
          [text | acc]
        end
      else
        acc
      end
    end)
    |> Enum.reverse()
  end

  @doc """

  ## Example
  iex> SecretHandshake.number_to_binary(8)
  [1, 0, 0, 0]
  iex> SecretHandshake.number_to_binary(5)
  [1, 0, 1]
  iex> SecretHandshake.number_to_binary(4)
  [1, 0, 0]
  """
  def number_to_binary(number) do
    number_to_binary_recursiv(number, [])
  end

  defp number_to_binary_recursiv(number, acc) do
    if number == 0 do
      acc
    else
      next_digit = rem(number, 2)
      rest = div(number, 2)
      number_to_binary_recursiv(rest, [next_digit | acc])
    end
  end
end
