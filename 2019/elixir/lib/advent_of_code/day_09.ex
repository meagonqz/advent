defmodule AdventOfCode.Day09 do
  alias AdventOfCode.CPU

  def input() do
    "assets/day09_input.txt"
    |> AdventOfCode.read_file()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1() do
    a =
      spawn(fn ->
        CPU.process_sequence(CPU.new(%{memory: input(), downstream: nil}))
      end)

    send(a, 1)

    receive do
      out ->
        out
    end
  end

  def part2() do
    a =
      spawn(fn ->
        CPU.process_sequence(CPU.new(%{memory: input(), downstream: nil}))
      end)

    send(a, 2)

    receive do
      out ->
        out
    end
  end
end
