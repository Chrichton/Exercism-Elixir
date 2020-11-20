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
  def insert(tree, data) do
    insert_recursive(tree, data)
    # if data < tree.data do
    #   if tree.left == nil do
    #     tree.left = new(data)
    #   else
    #     insert(tree.left, data)
    #   end
    # else
    #   if tree.right == nil do
    #     tree.right = new(data)
    #   else
    #     insert(tree.right, data)
    #   end
    # end
  end

  def insert_recursive(bst_node, data, path \\ []) do
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

  def build_tree(bst_node, path) do
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
  def in_order(tree) do
    # Your implementation here
  end
end