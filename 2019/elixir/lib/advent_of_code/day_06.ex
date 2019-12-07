defmodule AdventOfCode.Day06 do
  def produce_map(inputs) do
    inputs
    |> Enum.reduce(Map.new(), &set_in_map(&1, &2))
  end

  def set_in_map([a, b], map) do
    Map.update(map, a, [b], fn current -> [b | current] end)
  end

  def find_depths(map, current_key, depth, total) do
    case Map.has_key?(map, current_key) do
      true ->
        values =
          case length(Map.get(map, current_key)) do
            1 -> [total + depth]
            # Don't double count paths if there is more than one child
            2 -> [total + depth, 0]
          end

        Enum.with_index(Map.get(map, current_key))
        |> Enum.map(fn {key, key_number} ->
          find_depths(map, key, depth + 1, Enum.at(values, key_number))
        end)

      false ->
        total + depth
    end
  end

  def part1() do
    "assets/day06_input.txt"
    |> AdventOfCode.read_file()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ")", trim: true))
    |> produce_map()
    |> find_depths("COM", 0, 0)
    |> List.flatten()
    |> Enum.sum()
  end

  def test() do
    "COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L"
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ")", trim: true))
    |> produce_map()
    |> find_depths("COM", 0, 0)
    |> List.flatten()
    |> Enum.sum()
  end

  def produce_reverse_map(inputs) do
    inputs
    |> Enum.reduce(Map.new(), &set_in_map(&2, &1))
  end

  def part2() do
    "assets/day06_input.txt"
    |> AdventOfCode.read_file()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ")", trim: true))
    |> produce_reverse_map()

    # Todo: paths up to COM from me, paths up to COM from santa, find common path
  end
end
