defmodule AdventOfCode2018.Day01Test do
  use ExUnit.Case

  import AdventOfCode2018.Day01

  test "part1" do
    result = part1()

    assert 425 = result
  end

  test "part2" do
    result = part2()

    assert 57538 = result
  end
end
