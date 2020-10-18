defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    Enum.map(dna, &complement_nucleotide/1)
  end

  @spec complement_nucleotide(char) :: char
  defp complement_nucleotide(?G), do: ?C
  defp complement_nucleotide(?C), do: ?G
  defp complement_nucleotide(?T), do: ?A
  defp complement_nucleotide(?A), do: ?U
end
