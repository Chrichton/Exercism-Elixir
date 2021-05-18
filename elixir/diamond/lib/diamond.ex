defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(?A), do: "A\n"

  def build_shape(letter) do
    letters = get_letters(letter)
    max_index = String.length(letters) - 1
    max_width = get_max_width(max_index)
    build_lines(letters, max_width)
  end

  def build_lines(letters, max_width) do
    upper_diamond =
      letters
      |> String.codepoints()
      |> Enum.zip((String.length(letters) - 1)..0)
      |> Enum.map(fn {letter, padding} -> get_line(letter, padding, max_width) end)

    lower_diamond =
      upper_diamond
      |> Enum.take(Enum.count(upper_diamond) - 1)
      |> Enum.reverse()

    Enum.join(upper_diamond ++ lower_diamond, "\n") <> "\n"
  end

  def get_letters(letter) when letter >= ?A, do: ?A..letter |> Enum.to_list() |> List.to_string()

  def get_line("A", padding, _width) do
    String.duplicate(" ", padding) <> "A" <> String.duplicate(" ", padding)
  end

  def get_line(letter, padding, width) do
    String.duplicate(" ", padding) <>
      letter <>
      String.duplicate(" ", width - 2 * (padding + 1)) <> letter <> String.duplicate(" ", padding)
  end

  def get_max_width(max_index), do: max_index + 3
end
