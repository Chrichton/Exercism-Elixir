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
    |> String.trim_trailing()
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

  @spec transpose_recursive(any) :: [any]
  def transpose_recursive([[]]), do: []

  def transpose_recursive(rows) do
    {row, remaining_rows} = transpose_first_column(rows)
    [row | transpose_recursive(remaining_rows)]
  end

  def transpose_first_column(rows) do
    row = Enum.map(rows, fn [head | _] -> head end)
    remaining_rows = Enum.map(rows, fn [_ | tail] -> tail end)

    if is_empty(remaining_rows),
      do: {row, [[]]},
      else: {row, remaining_rows}
  end

  def is_empty(rows), do: Enum.flat_map(rows, fn x -> x end) == []
end
