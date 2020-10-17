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

  def multiples_of_number_upto_limit(number, limit) do
    count = div(limit - 1, number)

    if count < 1 do
      []
    else
      1..count
      |> Enum.map(fn _ -> number end)
      |> Enum.zip(1..count)
      |> Enum.map(fn {number, factor} -> number * factor end)
    end
  end
end
