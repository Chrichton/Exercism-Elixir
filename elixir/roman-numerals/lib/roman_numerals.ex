defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """

  @roman_digits_to_numbers %{
    "M" => 1000,
    "D" => 500,
    "C" => 100,
    "L" => 50,
    "X" => 10,
    "V" => 5,
    "I" => 1
  }

  @numbers_to_roman_digits for {roman_numeral, number} <- @roman_digits_to_numbers,
                               into: %{},
                               do: {number, roman_numeral}

  def numeral(1), do: @numbers_to_roman_digits[1]
  def numeral(5), do: @numbers_to_roman_digits[5]
  def numeral(10), do: @numbers_to_roman_digits[10]
  def numeral(50), do: @numbers_to_roman_digits[50]
  def numeral(100), do: @numbers_to_roman_digits[100]
  def numeral(500), do: @numbers_to_roman_digits[500]
  def numeral(1000), do: @numbers_to_roman_digits[1000]

  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    sorted_roman_literals()
    |> Enum.reduce({number, ""}, fn roman_digit, accu ->
      numeral_number(accu, roman_digit)
    end)
    |> elem(1)
    |> compact_4_adjacend_identical_roman_digits()
  end

  # number: number to convert to roman
  # current_roman_number: roman number so far
  # roman_digit: one of "M", "D", "C", "L", "X", "V", "I"
  # returns {remaining number, new roman_number}
  @spec numeral_number({pos_integer, String.t()}, String.t()) :: {pos_integer(), String.t()}
  defp numeral_number({number, current_roman_number}, roman_digit)
       when roman_digit in ["M", "D", "C", "L", "X", "V", "I"] do
    factor = Map.fetch!(@roman_digits_to_numbers, roman_digit)

    if number >= factor do
      number_of = div(number, factor)
      roman = String.duplicate(roman_digit, number_of)
      rest = number - number_of * factor
      {rest, current_roman_number <> roman}
    else
      {number, current_roman_number}
    end
  end

  defp compact_4_adjacend_identical_roman_digits(roman_number) do
    roman_number
    # 900
    |> String.replace("DCCCC", "CM")
    # 400
    |> String.replace("CCCC", "CD")
    # 90
    |> String.replace("LXXXX", "XC")
    # 40
    |> String.replace("XXXX", "XL")
    #  9
    |> String.replace("VIIII", "IX")
    #  4
    |> String.replace("IIII", "IV")
  end

  defp sorted_roman_literals() do
    @roman_digits_to_numbers
    |> Map.to_list()
    |> Enum.sort(fn {_, v1}, {_, v2} -> v1 > v2 end)
    |> Enum.map(fn tuple -> elem(tuple, 0) end)
  end
end
