defmodule Mix.Tasks.D09.P2 do
  use Mix.Task

  import AdventOfCode.Day09

  @shortdoc "Day 09 Part 2"
  def run(args) do
    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> part2() end}),
      else:
        part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
