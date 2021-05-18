defmodule DiamondTest do
  use ExUnit.Case

  test "get_letters" do
    assert Diamond.get_letters(?A) == "A"
    assert Diamond.get_letters(?D) == "ABCD"
  end

  test "get_width" do
    assert Diamond.get_width(0) == 1
    assert Diamond.get_width(1) == 3
    assert Diamond.get_width(2) == 5
    assert Diamond.get_width(3) == 7
  end

  test "get_line" do
    assert Diamond.get_line("A", 2, 5) == "  A  "
    assert Diamond.get_line("B", 1, 5) == " B B "
    assert Diamond.get_line("C", 0, 5) == "C   C"
    assert Diamond.get_line("C", 1, 6) == " C  C "
  end

  # @tag :pending
  test "letter A" do
    shape = Diamond.build_shape(?A)
    assert shape == "A\n"
  end

  # @tag :pending
  test "letter C" do
    shape = Diamond.build_shape(?C)

    assert shape == """
           \s A \s
           \sB B\s
           C   C
           \sB B\s
           \s A \s
           """
  end

  # @tag :pending
  test "letter E" do
    shape = Diamond.build_shape(?E)

    assert shape == """
           \s   A   \s
           \s  B B  \s
           \s C   C \s
           \sD     D\s
           E       E
           \sD     D\s
           \s C   C \s
           \s  B B  \s
           \s   A   \s
           """
  end
end
