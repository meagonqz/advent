defmodule Mix.Tasks.D09.P1 do
  use Mix.Task

  import AdventOfCode.Day09

  @shortdoc "Day 09 Part 1"
  def run(args) do

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> part1() end}),
      else:
        part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
