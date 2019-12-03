defmodule AdventOfCode2018.Day01 do
  def read_file() do
    case File.read("assets/day1/input") do
      {:ok, input} -> input
      {:error, reason} -> IO.inspect(reason, label: "Error reading file: ")
    end
  end

  def part1() do
    detect_frequency(read_file())
  end

  def detect_frequency(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(0, &(&1 + &2))
  end

  def detect_frequency_with_set(input) do
    input =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    input
    |> List.duplicate(300)
    |> List.flatten()
    |> Enum.reduce_while(%{value: 0, set: MapSet.new()}, &check_or_update_set/2)
  end

  def check_or_update_set(value, acc) do
    new_value = acc.value + value

    case MapSet.member?(acc.set, new_value) do
      true -> {:halt, new_value}
      false -> {:cont, %{value: new_value, set: MapSet.put(acc.set, new_value)}}
    end
  end

  def part2() do
    detect_frequency_with_set(read_file())
  end
end
