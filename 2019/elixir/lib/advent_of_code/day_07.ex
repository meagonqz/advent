defmodule AdventOfCode.Day07 do
  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

  def part1() do
    permutations([4, 3, 2, 1, 0])
    |> run_phases()
  end

  def run_phases(phases) do
    phases
    |> Enum.map(&scan_each_phase(&1))
    |> Enum.map(&Enum.to_list/1)
    |> Enum.map(&Enum.drop(&1, 4))
    |> List.flatten()
    |> Enum.max()
  end

  def scan_each_phase(sequence) do
    Stream.scan(sequence, 0, &process_phase(&1, &2))
  end

  def process_phase(phase, input) do
    "assets/day07_input.txt"
    |> AdventOfCode.read_file()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> process_sequence(phase, input)
  end

  def process_sequence(puzzle_input, phase, input) do
    AdventOfCode.Day05.process_sequence(puzzle_input, [phase, input], true)
  end

  def test() do
    input =
      "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    Stream.scan([4, 3, 2, 1, 0], 0, &process_sequence(input, &1, &2))
    |> Enum.to_list()
    |> IO.inspect()
  end

  def part2() do
  end
end
