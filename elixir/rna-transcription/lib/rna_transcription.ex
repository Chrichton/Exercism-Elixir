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

  @spec complement_nucleotide(integer) :: integer
  defp complement_nucleotide(nucleotide) do
    case nucleotide do
      ?G -> ?C
      ?C -> ?G
      ?T -> ?A
      ?A -> ?U
    end
  end
end
