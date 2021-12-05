defmodule AdventOfCode.Day01 do
  def example_input do
    """
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """
  end

  def count_increases(input) do
    input
    |> Enum.reduce(
      %{count: 0, prev: nil},
      fn x, acc ->
        case x > acc.prev and not is_nil(acc.prev) do
          true -> %{count: acc.count + 1, prev: x}
          false -> %{acc | prev: x}
        end
      end
    )
  end

  # oops I forgot about Elixir's chunk
  #|> Enum.chunk_by/Enum.chunk_every(2, 1, :discard)
  # also Enum.count/2 !
  #|> Enum.count(fn [left, right] -> right > left end)
  def part1(args \\ example_input()) do
    input = args |> String.split("\n", trim: true)

    final =
      input
      |> Enum.map(&String.to_integer/1)
      |> count_increases()

    final.count
  end

  def window_scan(input, start) do
    input
    |> Enum.reduce(
      start,
      fn x, acc ->
        window = acc.window
        results = acc.results
        window_length = Enum.count(window)

        case window_length do
          3 ->
            [_head | tail] = window
            next_window = tail ++ [x]
            %{results: results ++ [Enum.sum(window)], window: next_window}

          _ ->
            %{results: results, window: window ++ [x]}
        end
      end
    )
  end

  def part2(args \\ example_input()) do
    input = args |> String.split("\n", trim: true)

    results =
      input
      |> Enum.map(&String.to_integer/1)
      |> window_scan(%{results: [], window: []})

    last_round =
      (results.window ++ [0])
      |> window_scan(results)

    final =
      last_round.results
      |> count_increases()

    final.count
  end
end
