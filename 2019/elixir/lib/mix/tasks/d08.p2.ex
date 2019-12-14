defmodule Mix.Tasks.D08.P2 do
  use Mix.Task

  import AdventOfCode.Day08

  @shortdoc "Day 08 Part 2"
  def run(args) do
    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> part2() end}),
      else:
        part2()
  end
end
