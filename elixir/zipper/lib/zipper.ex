defmodule Zipper do
  @doc """
  Get a zipper focused on the root node.
  """

  defstruct focus: nil, tree: nil
  @type t :: %__MODULE__{focus: BinTree.t(), tree: BinTree.t()}

  @spec from_tree(BinTree.t()) :: Zipper.t()

  def from_tree(bin_tree) do
    %Zipper{focus: bin_tree, tree: bin_tree}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(zipper) do
    zipper.tree
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(zipper) do
    zipper.focus.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(zipper) do
    left = zipper.focus.left

    if left == nil,
      do: nil,
      else: %Zipper{focus: left, tree: zipper.tree}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(zipper) do
    right = zipper.focus.right

    if right == nil,
      do: nil,
      else: %Zipper{focus: right, tree: zipper.tree}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(zipper) do
    parent = find_parent_node_in_tree(zipper.focus, zipper.tree, nil)

    if parent == nil,
      do: nil,
      else: %Zipper{focus: parent, tree: zipper.tree}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    node = %BinTree{value: value, left: zipper.focus.left, right: zipper.focus.right}
    parent = find_parent_node_in_tree(zipper.focus, zipper.tree, nil)
    tree = build_tree(zipper.focus, node, parent, zipper.tree)

    %Zipper{focus: node, tree: tree}
  end

  defp build_tree(_old_node, node, nil, _tree) do
    node
  end

  defp build_tree(old_node, node, %BinTree{left: left} = tree, old_tree) when old_node == left do
    new_tree = %BinTree{value: tree.value, left: node, right: tree.right}
    parent = find_parent_node_in_tree(tree, old_tree, nil)
    build_tree(tree, new_tree, parent, old_tree)
  end

  defp build_tree(old_node, node, %BinTree{right: right} = tree, old_tree)
       when old_node == right do
    new_tree = %BinTree{value: tree.value, left: tree.left, right: node}
    parent = find_parent_node_in_tree(tree, old_tree, nil)
    build_tree(tree, new_tree, parent, old_tree)
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    node = %BinTree{value: zipper.focus.value, left: left, right: zipper.focus.right}

    parent = find_parent_node_in_tree(zipper.focus, zipper.tree, nil)
    tree = build_tree(zipper.focus, node, parent, zipper.tree)

    %Zipper{focus: node, tree: tree}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    node = %BinTree{value: zipper.focus.value, left: zipper.focus.left, right: right}

    parent = find_parent_node_in_tree(zipper.focus, zipper.tree, nil)
    tree = build_tree(zipper.focus, node, parent, zipper.tree)

    %Zipper{focus: node, tree: tree}
  end

  defp find_parent_node_in_tree(_node, nil, _parent), do: nil
  defp find_parent_node_in_tree(node, tree, parent) when node == tree, do: parent

  defp find_parent_node_in_tree(node, tree, _parent) do
    parent = find_parent_node_in_tree(node, tree.left, tree)

    if parent != nil,
      do: parent,
      else: find_parent_node_in_tree(node, tree.right, tree)
  end
end
