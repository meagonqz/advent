defmodule AdventOfCode.Day02 do
  @opcode_length 4

  def part1(args \\ "assets/day02_input.txt") do
    args
    |> AdventOfCode.read_file()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> process_sequence()
  end

  def process_sequence(input) do
    input
    |> Enum.chunk_every(@opcode_length)
    |> process_opcode(input)
  end

  def process_opcode([[1, i, i2, result] | rest], input) do
    input = List.replace_at(input, result, Enum.at(input, i) + Enum.at(input, i2))
    process_opcode(rest, input)
  end

  def process_opcode([[2, i, i2, result] | rest], input) do
    input = List.replace_at(input, result, Enum.at(input, i) * Enum.at(input, i2))
    process_opcode(rest, input)
  end

  def process_opcode([[99, _, _, _] | _], input) do
    Enum.at(input, 0)
  end

  def part2(args \\ "assets/day02_input.txt") do
    input =
      "assets/day02_input.txt"
      |> AdventOfCode.read_file()
      |> String.trim()
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    generate_combinations()
    |> Enum.drop_while(&(try_combination(&1, input) !== 19_690_720))
    |> Enum.take(1)
    |> Enum.at(0)
  end

  def generate_combinations() do
    for x <- 0..99, y <- 0..99, do: [x, y]
  end

  def try_combination([val1, val2], input) do
    input
    |> List.replace_at(1, val1)
    |> List.replace_at(2, val2)
    |> process_sequence()
  end
end
