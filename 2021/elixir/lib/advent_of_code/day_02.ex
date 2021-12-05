defmodule AdventOfCode.Day02 do

  defmodule Coord do
    @typedoc """
      Type that represents coordinates struct with x and y as integers
    """
    @type x :: integer
    @type y :: integer

    defstruct x: 0, y: 0

    @type t(x, y) :: %Coord{x: x, y: y}

    @type t :: %Coord{x: integer, y: integer}

    @spec forward(Coord.t(), integer) :: Coord.t()
    def forward(%Coord{x: x, y: y}, x2) do
      %Coord{x: x + x2, y: y}
    end

    @spec down(Coord.t(), integer) :: Coord.t()
    def down(%Coord{x: x, y: y}, y2) do
      %Coord{x: x, y: y + y2}
    end

    @spec up(Coord.t(), integer) :: Coord.t()
    def up(%Coord{x: x, y: y}, y2) do
      %Coord{x: x, y: y - y2}
    end
  end

  def part1(args) do
    start = %Coord{}
    input =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.split(x, " ") end)
      |> Enum.map(fn [dir, y] -> [dir, String.to_integer(y)] end)
    results =
      input
    |> Enum.reduce(start, fn ([direction, units], acc) ->
      case direction do
        "forward" -> Coord.forward(acc, units)
        "down" -> Coord.down(acc, units)
        "up" -> Coord.up(acc, units)
      end
    end)

    results.x * results.y
  end

  def part2(args) do
  end
end
