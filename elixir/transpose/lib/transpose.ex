defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples
  iex> Transpose.transpose("ABC\nDE")
  "AD\nBE\nC"

  iex> Transpose.transpose("AB\nDEF")
  "AD\nBE\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(input) do
    input
    |> to_rows()
    |> transpose_recursive()
    |> Enum.join("\n")
  end

  def transpose_recursive(rows) do
    {row, remaining_rows} = transpose_first_column(rows)

    if Enum.flat_map(remaining_rows, fn x -> x end) == [],
      do: row,
      else: [row | transpose_recursive(remaining_rows)]
  end

  # "ab\ncd" -> [["a", "b"], ["c", "d"]]
  def to_rows(input) do
    input
    |> String.split("\n")
    |> pad_right()
    |> Enum.map(&String.codepoints/1)
  end

  def pad_right(lines) do
    max_line_length = Enum.max_by(lines, &String.length/1) |> String.length()
    Enum.map(lines, fn line -> String.pad_trailing(line, max_line_length) end)
  end

  # empty list
  def transpose_first_column([[]]), do: {[], []}

  def transpose_first_column(rows),
    do: {Enum.map(rows, fn [head | _] -> head end), Enum.map(rows, fn [_ | tail] -> tail end)}
end
