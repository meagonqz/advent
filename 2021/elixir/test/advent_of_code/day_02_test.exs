defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1" do
    input = """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """
    result = part1(input)

    assert result == 150
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
