defmodule AdventOfCode.Day10 do
  def part1() do
    parsed =
      "assets/day10_input.txt"
      |> AdventOfCode.read_file()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    y_max = length(parsed) - 1
    x_max = length(Enum.at(parsed, 0)) - 1
    bounds = [0, 0, x_max, y_max]

    parsed
    |> Enum.with_index()
    |> Enum.map(fn {line, x} ->
      line
      |> Enum.with_index()
      |> Enum.map(fn {elem, y} -> get_asteroid(elem, {x, y}) end)
      |> Enum.reject(&is_nil/1)
      |> List.flatten()
    end)
    |> List.flatten()
    |> asteroids_with_set()
    |> (fn {asteroids, set} -> Enum.map(asteroids, &find_visible(&1, asteroids, set, bounds)) end).()
    |> Enum.max_by(fn {_, count} -> count end)

    # get_asteroids()
  end

  def get_asteroid(".", _index) do
    nil
  end

  def get_asteroid("#", {x, y}) do
    {x, y}
  end

  def asteroids_with_set(asteroids) do
    set = MapSet.new(asteroids)
    {asteroids, set}
  end

  def find_visible({x, y}, asteroids, set, bounds) do
    count =
      asteroids
      |> Enum.reject(&(&1 == {x, y}))
      |> Enum.map(&visible?({x, y}, &1, set, bounds))
      |> Enum.filter(& &1)
      |> Enum.count()

    {{x, y}, count}
  end

  def visible?(other, other, _asteroid_set, _bounds), do: true

  def visible?({x1, y1}, _other, _asteroid_set, [xmin, ymin, xmax, ymax])
      when x1 < xmin or x1 > xmax or y1 < ymin or y1 > ymax,
      do: false

  def visible?({x1, y1}, other = {x2, y2}, asteroid_set, bounds) do
    {rise, run} = {y2 - y1, x2 - x1} |> rise_over_run()
    step = {x1 + run, y1 + rise}

    cond do
      step == other ->
        true

      MapSet.member?(asteroid_set, step) ->
        false

      true ->
        visible?(step, other, asteroid_set, bounds)
    end
  end

  def rise_over_run({a, b}) do
    gcd = Integer.gcd(a, b)
    {div(a, gcd), div(b, gcd)}
  end

  def part2() do
  end
end
