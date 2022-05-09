defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _), do: %{}

  def frequency(texts, workers) do
    text_length = length(texts)

    chunks =
      if text_length < workers,
        do: text_length,
        else: div(text_length, workers)

    Enum.chunk_every(texts, chunks)
    |> Enum.map(&Task.async(fn -> calculate_frequencies(&1) end))
    |> Task.await_many(500)
    |> Enum.reduce(Map.new(), &merge_maps_by_adding_values/2)
  end

  def calculate_frequencies(texts) do
    texts
    |> Enum.reduce(Map.new(), fn string, acc ->
      string
      |> String.trim()
      |> String.downcase()
      |> String.codepoints()
      |> Enum.reject(&(&1 in [",", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]))
      |> Enum.frequencies()
      |> merge_maps_by_adding_values(acc)
    end)
  end

  defp merge_maps_by_adding_values(map1, map2) do
    Map.merge(map1, map2, fn _k, v1, v2 -> v1 + v2 end)
  end
end
