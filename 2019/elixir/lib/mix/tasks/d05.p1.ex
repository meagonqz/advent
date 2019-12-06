defmodule Mix.Tasks.D05.P1 do
  use Mix.Task

  import AdventOfCode.Day05

  @shortdoc "Day 05 Part 1"
  def run(args) do
    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> part1() end}),
      else:
        part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
