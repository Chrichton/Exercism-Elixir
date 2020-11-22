defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    %{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(tree, data), do: insert_recursive(tree, data)

  defp insert_recursive(bst_node, data, path \\ []) do
    if data <= bst_node.data do
      if bst_node.left == nil do
        %{data: bst_node.data, left: new(data), right: bst_node.right}
        |> build_tree(path)
      else
        insert_recursive(bst_node.left, data, [{bst_node, :left} | path])
      end
    else
      if bst_node.right == nil do
        %{data: bst_node.data, left: bst_node.left, right: new(data)}
        |> build_tree(path)
      else
        insert_recursive(bst_node.right, data, [{bst_node, :right} | path])
      end
    end
  end

  defp build_tree(bst_node, path) do
    Enum.reduce(path, bst_node, fn {node, direction}, acc ->
      case direction do
        :left -> %{data: node.data, left: acc, right: node.right}
        :right -> %{data: node.data, left: node.left, right: acc}
      end
    end)
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree), do: in_order_recursive(tree)

  defp in_order_recursive(nil), do: []

  defp in_order_recursive(bst_node) do
    get_path_recursive(bst_node)
    |> Enum.reduce([], fn node, acc ->
      [node.data | in_order_recursive(node.right)] ++ acc
    end)
  end

  defp get_path_recursive(nil), do: []

  defp get_path_recursive(bst_node),
    do: [bst_node | get_path_recursive(bst_node.left)]
end
