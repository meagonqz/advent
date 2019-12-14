defmodule AdventOfCode.Day08 do
  @rowCount 25
  @colCount 6
  defmodule Layer do
    defstruct rows: [], rowCount: nil, colCount: nil
  end

  def part1() do
    "assets/day08_input.txt"
    |> AdventOfCode.read_file()
    |> String.split("\n")
    |> Enum.at(0)
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> to_layers()
    |> Enum.map(&find_number(&1, 0))
    |> Enum.min_by(fn {num_zeros, _} -> num_zeros end)
    |> (fn {_, layer} -> find_number(layer, 1) end).()
    |> (fn {num_ones, layer} -> num_ones * elem(find_number(layer, 2), 0) end).()
  end

  def to_layers(numbers) do
    numbers
    |> Enum.chunk_every(@rowCount)
    |> Enum.chunk_every(@colCount)
    |> Enum.map(fn layer -> %Layer{rows: layer, rowCount: @rowCount, colCount: @colCount} end)
  end

  def find_number(%Layer{rows: rows} = layer, digit) do
    {Enum.map(rows, fn row ->
       Enum.count(row, fn num -> num == digit end)
     end)
     |> Enum.sum(), layer}
  end

  def part2() do
    message = List.duplicate(List.duplicate(nil, 25), 6)

    "assets/day08_input.txt"
    |> AdventOfCode.read_file()
    |> String.split("\n")
    |> Enum.at(0)
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> to_layers()
    |> Enum.reduce(message, &compute_values(&1, &2))
    |> Enum.map(fn row ->
      Enum.reduce(row, "", fn num, line -> if num == 0, do: line <> " ", else: line <> "@" end)
    end)
    |> IO.inspect(width: 26)
  end

  def compute_values(%Layer{rows: rows}, message) do
    rows
    |> Enum.with_index()
    |> Enum.map(fn {row, colIndex} -> update_message(row, Enum.at(message, colIndex), []) end)
  end

  def update_message([num | tail], [current | rest], new_message) do
    value =
      case current do
        nil -> num
        2 -> num
        _ -> current
      end

    update_message(tail, rest, new_message ++ [value])
  end

  def update_message([], [], new_message) do
    new_message
  end
end
