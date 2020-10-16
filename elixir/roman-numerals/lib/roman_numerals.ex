defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  def numeral(1), do: "I"
  def numeral(5), do: "V"
  def numeral(10), do: "X"
  def numeral(50), do: "L"
  def numeral(100), do: "C"
  def numeral(500), do: "D"
  def numeral(1000), do: "M"

  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    roman_number = ""

    {roman_number, number} = if number >= 1000 do
      number_of = div(number, 1000)
      roman = String.duplicate(numeral(1000), number_of)
      rest = number - number_of * 1000
      {roman_number <> roman, rest}
    else
      {roman_number, number}
    end

    {roman_number, number} = if number >= 500 do
      number_of = div(number, 500)
      roman = String.duplicate(numeral(500), number_of)
      rest = number - number_of * 500
      {roman_number <> roman, rest}
    else
      {roman_number, number}
    end

    {roman_number, number} = if number >= 100 do
      number_of = div(number, 100)
      roman = String.duplicate(numeral(100), number_of)
      rest = number - number_of * 100
      {roman_number <> roman, rest}
    else
      {roman_number, number}
    end

    {roman_number, number} = if number >= 50 do
      number_of = div(number, 50)
      roman = String.duplicate(numeral(50), number_of)
      rest = number - number_of * 50
      {roman_number <> roman, rest}
    else
      {roman_number, number}
    end

    {roman_number, number} = if number >= 10 do
      number_of = div(number, 10)
      roman = String.duplicate(numeral(10), number_of)
      rest = number - number_of * 10
      {roman_number <> roman, rest}
    else
      {roman_number, number}
    end

    {roman_number, number} = if number >= 5 do
      number_of = div(number, 5)
      roman = String.duplicate(numeral(5), number_of)
      rest = number - number_of * 5
      {roman_number <> roman, rest}
    else
      {roman_number, number}
    end

    {roman_number, _} = if number >= 1 do
      number_of = div(number, 1)
      roman = String.duplicate(numeral(1), number_of)
      rest = number - number_of * 1
      {roman_number <> roman, rest}
    else
      {roman_number, number}
    end

    remove_4_occurrences(roman_number)
  end

  defp remove_4_occurrences(roman_number) do
    roman_number
      |> String.replace("DCCCC", "CM")  #900
      |> String.replace("CCCC", "CD")   #400
      |> String.replace("LXXXX", "XC")  # 90
      |> String.replace("XXXX", "XL")   # 40
      |> String.replace("VIIII", "IX")  #  9
      |> String.replace("IIII", "IV")   #  4
  end
end
