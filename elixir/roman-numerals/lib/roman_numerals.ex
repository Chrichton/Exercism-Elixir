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

    {roman_number, number} = numeral_number(number, roman_number, 1000)
    {roman_number, number} = numeral_number(number, roman_number, 500)
    {roman_number, number} = numeral_number(number, roman_number, 100)
    {roman_number, number} = numeral_number(number, roman_number, 50)
    {roman_number, number} = numeral_number(number, roman_number, 10)
    {roman_number, number} = numeral_number(number, roman_number, 5)
    {roman_number, _} = numeral_number(number, roman_number, 1)

    remove_4_occurrences(roman_number)
  end

  defp numeral_number(number, current_roman_number, factor) do
    if number >= factor do
      number_of = div(number, factor)
      roman = String.duplicate(numeral(factor), number_of)
      rest = number - number_of * factor
      {current_roman_number <> roman, rest}
    else
      {current_roman_number, number}
    end
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