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
      |> Enum.reduce(%{}, fn x, acc ->
        case Map.fetch(acc, x) do
          {:ok, count} -> Map.put(acc, x, count + 1)
          _ -> Map.put_new(acc, x, 1)
        end
      end )
  end

  defp ignore_punctuation(word) do
    punctuation = String.codepoints(",:!&@$%^&)\"")
    Enum.filter(String.codepoints(word), fn character ->
      character not in punctuation end)
    |> List.to_string()
  end
end
