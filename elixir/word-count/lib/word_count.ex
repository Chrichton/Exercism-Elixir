defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    String.downcase(sentence)
    |> String.replace("_", " ")
    |> ignore_punctuation()
    |> String.split(" ", trim: true)
    |> Enum.reduce(%{}, fn char, acc ->
      Map.update(acc, char, 1, &(&1 + 1))
    end)
  end

  defp ignore_punctuation(word) do
    punctuation = String.codepoints(",:!&@$%^&)\"")

    Enum.filter(String.codepoints(word), fn character ->
      character not in punctuation
    end)
    |> List.to_string()
  end
end
