defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  # @type list:: [] | any() : list

  @spec count(list) :: non_neg_integer
  def count([]), do: 0
  def count([_ | rest]), do: 1 + count(rest)

  @spec reverse(list) :: list
  def reverse(l), do: reverse_recursive(l, [])

  defp reverse_recursive([], acc), do: acc

  defp reverse_recursive([head | rest], acc),
    do: reverse_recursive(rest, [head | acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: map_recursive(l, f, [])

  defp map_recursive([], _, acc), do: reverse(acc)

  defp map_recursive([head | rest], f, acc), do: map_recursive(rest, f, [f.(head) | acc])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: filter_recursive(l, f, [])

  defp filter_recursive([], _, acc), do: reverse(acc)

  defp filter_recursive([head | rest], f, acc),
    do:
      if(f.(head),
        do: filter_recursive(rest, f, [head | acc]),
        else: filter_recursive(rest, f, acc)
      )

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _), do: acc

  def reduce([head | rest], acc, f) do
    reduce(rest, f.(head, acc), f)
  end

  @spec append(list, list) :: list
  def append(a, b), do: append_recursive(reverse(a), b)

  defp append_recursive([], accu), do: accu
  defp append_recursive([head | rest], accu), do: append_recursive(rest, [head | accu])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: concat_recursive(reverse(ll), [])

  defp concat_recursive([], accu), do: accu

  defp concat_recursive([list | rest], accu), do: concat_recursive(rest, append(list, accu))
end
