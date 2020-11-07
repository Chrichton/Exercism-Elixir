defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base_frequency =
      base
      |> String.upcase()
      |> String.codepoints()
      |> Enum.frequencies()

    candidates
    |> Enum.map(&(String.replace(&1, "~w(", "") |> String.replace(")", "")))
    |> Enum.reduce([], fn str, acc ->
      if String.upcase(str) != String.upcase(base) &&
           Enum.frequencies(String.codepoints(String.upcase(str))) == base_frequency,
         do: [str | acc],
         else: acc
    end)
    |> Enum.reverse()
  end
end
