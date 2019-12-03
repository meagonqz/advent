defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "initial_fuel" do
    input = [12, 14, 1969, 100_756]
    assert Enum.map(input, &initial_fuel/1) == [2, 2, 654, 33583]
  end

  test "part1" do
    assert part1() == 3_327_415
  end

  test "fuel_required" do
    input = [14, 1969, 100_756]
    assert Enum.map(input, &fuel_required/1) == [2, 966, 50346]
  end

  test "part2" do
    assert part2() == 4_988_257
  end
end
