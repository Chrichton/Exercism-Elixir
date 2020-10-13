defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    Enum.zip([3, 5 ,7], ["Pling", "Plang", "Plong"])
      |> Enum.reduce("", fn {divisor, sound}, accu  ->
        case rem(number, divisor) do
          0 -> accu <> sound
          _ -> accu
        end
      end)
      |> to_output(number)
  end

  defp to_output("", number) do
    Integer.to_string(number)
  end

  defp to_output(sound, _) do
    sound
  end

  # # Why does this not work?
  # def convert2(number) do
  #   result = ""

  #   if rem(number, 3) == 0 do
  #     result = result <> "Pling"
  #   end

  #   if rem(number, 5) == 0 do
  #     result = result <> "Plang"
  #   end

  #   if rem(number, 5) == 0 do
  #     result = result <> "Plong"
  #   end

  #   if result == '' do
  #     Integer.to_string(number)
  #   end
  # end
end
