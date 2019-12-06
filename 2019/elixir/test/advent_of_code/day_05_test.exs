defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  test "part1" do
    "3,9,8,9,10,9,4,9,99,-1,8"
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> process_sequence()

    assert 1 == 1
  end

  @tag :skip
  test "part2" do
  end
end
