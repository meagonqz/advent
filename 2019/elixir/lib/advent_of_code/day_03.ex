defmodule AdventOfCode.Day03 do
  def calculate_coords(instructions) do
    instructions
    |> String.split(",")
    |> Enum.reduce(%{x: 0, y: 0, points: Map.new(), distance: 0}, &process_instruction(&1, &2))
  end

  def process_instruction("U" <> s, %{x: x, y: y, points: points, distance: distance}) do
    count = String.to_integer(s)
    points = Enum.reduce(1..count, points, &Map.put_new(&2, [x, y + &1], distance + &1))
    %{x: x, y: y + count, points: points, distance: distance + count}
  end

  def process_instruction("D" <> s, %{x: x, y: y, points: points, distance: distance}) do
    count = String.to_integer(s)
    points = Enum.reduce(1..count, points, &Map.put_new(&2, [x, y - &1], distance + &1))
    %{x: x, y: y - count, points: points, distance: distance + count}
  end

  def process_instruction("R" <> s, %{x: x, y: y, points: points, distance: distance}) do
    count = String.to_integer(s)
    points = Enum.reduce(1..count, points, &Map.put_new(&2, [x + &1, y], distance + &1))
    %{x: x + count, y: y, points: points, distance: distance + count}
  end

  def process_instruction("L" <> s, %{x: x, y: y, points: points, distance: distance}) do
    count = String.to_integer(s)
    points = Enum.reduce(1..count, points, &Map.put_new(&2, [x - &1, y], distance + &1))
    %{x: x - count, y: y, points: points, distance: distance + count}
  end

  def manhattan_distance([x, y]) do
    abs(x) + abs(y)
  end

  def part1() do
    [wire1, wire2] =
      "assets/day03_input.txt"
      |> AdventOfCode.read_file()
      |> String.split("\n", trim: true)
      |> Enum.map(fn wire -> calculate_coords(wire) end)

    wire1set = wire1.points |> Map.keys() |> MapSet.new() |> MapSet.delete([0, 0])
    wire2set = wire2.points |> Map.keys() |> MapSet.new() |> MapSet.delete([0, 0])
    intersections = MapSet.intersection(wire1set, wire2set)

    intersections
    |> Enum.map(&manhattan_distance/1)
    |> Enum.min()
  end

  def part2() do
    [wire1, wire2] =
      "assets/day03_input.txt"
      |> AdventOfCode.read_file()
      |> String.split("\n", trim: true)
      |> Enum.map(fn wire -> calculate_coords(wire) end)

    wire1set = wire1.points |> Map.keys() |> MapSet.new() |> MapSet.delete([0, 0])
    wire2set = wire2.points |> Map.keys() |> MapSet.new() |> MapSet.delete([0, 0])
    intersections = MapSet.intersection(wire1set, wire2set)

    intersections
    |> Enum.reduce([], &[Map.get(wire1.points, &1) + Map.get(wire2.points, &1) | &2])
    |> Enum.min()
  end
end
