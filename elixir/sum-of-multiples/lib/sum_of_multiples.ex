defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    factors
    |> Enum.flat_map(fn factor ->
      multiples_of_number_upto_limit(factor, limit)
    end)
    |> Enum.uniq()
    |> Enum.sum()
  end

  defmacrop count(number, limit), do: div(limit - 1, number)

  def multiples_of_number_upto_limit(number, limit)
      when count(number, limit) == 0,
      do: []

  def multiples_of_number_upto_limit(number, limit) do
    count = count(number, limit)

    Enum.map(1..count, fn factor -> number * factor end)
  end
end
