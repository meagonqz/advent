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

  def traverse(_map, nil, _visited, _last) do
    []
  end

  def traverse(_map, last, visited, last) do
    visited
  end

  def traverse(map, current, visited, last) do
    next = Map.get(map, current)
    Enum.map(next, &traverse(map, &1, [&1 | visited], last))
  end

  def produce_reverse_map(inputs) do
    inputs
    |> Enum.reduce(Map.new(), &set_in_map(Enum.reverse(&1), &2))
  end

  def part2() do
    map =
      "assets/day06_input.txt"
      |> AdventOfCode.read_file()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ")", trim: true))
      |> produce_reverse_map()

    my_path_to_root =
      map
      |> traverse("YOU", [], "COM")
      |> List.flatten()

    santa_path_to_root =
      map
      |> traverse("SAN", [], "COM")
      |> List.flatten()

    my_path_to_common_ancestor = my_path_to_root -- santa_path_to_root
    san_path_to_common_ancestor = santa_path_to_root -- my_path_to_root
    IO.inspect((my_path_to_common_ancestor ++ san_path_to_common_ancestor) |> length())
  end
end
