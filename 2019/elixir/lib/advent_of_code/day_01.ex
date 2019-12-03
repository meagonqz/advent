defmodule AdventOfCode.Day01 do
  def read_file(args) do
    case File.read(args) do
      {:ok, input} -> input
      {:error, reason} -> IO.inspect(reason, label: "Error reading file: ")
    end
  end

  def initial_fuel(mass) do
    div(mass, 3) - 2
  end

  def fuel_required(mass) do
    current = initial_fuel(mass)

    if current > 0 do
      current + fuel_required(current)
    else
      0
    end
  end

  def part1(args \\ "assets/day01_input.txt") do
    args
    |> read_file()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&initial_fuel/1)
    |> Enum.reduce(0, &(&1 + &2))
  end

  def part2(args \\ "assets/day01_input.txt") do
    args
    |> read_file()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&fuel_required/1)
    |> Enum.reduce(0, &(&1 + &2))
  end
end
