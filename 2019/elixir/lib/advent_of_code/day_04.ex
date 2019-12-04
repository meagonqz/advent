defmodule AdventOfCode.Day04 do
  def part1() do
    256_310..732_736
    |> Enum.filter(&has_atleast_one_double_p1?(&1))
    |> Enum.filter(&has_consecutive_digits?(&1))
    |> Enum.count()
  end

  def has_atleast_one_double_p1?(number) do
    doubles =
      number
      |> Integer.digits()
      |> Enum.reduce(%{last: 0, list: []}, &is_a_double_p1?(&1, &2))

    length(doubles.list) > 0
  end

  def is_a_double_p1?(x, %{last: y, list: acc}) do
    if y == x do
      %{last: x, list: [x | acc]}
    else
      %{last: x, list: acc}
    end
  end

  def has_atleast_one_double?(number) do
    digits = number |> Integer.digits()
    consec = Enum.reduce(digits, %{last: 0, list: [], prev: false}, &is_a_double?(&1, &2))
    length(consec.list) > 0
  end

  def is_a_double?(x, %{last: y, list: acc, prev: prev}) do
    if y == x do
      if prev do
        %{last: x, list: remove_if_exists(x, acc), prev: true}
      else
        %{last: x, list: [x | acc], prev: true}
      end
    else
      %{last: x, list: acc, prev: false}
    end
  end

  def remove_if_exists(x, acc) do
    if Enum.member?(acc, x) do
      List.delete_at(acc, 0)
    else
      acc
    end
  end

  def has_consecutive_digits?(number) do
    consec =
      number
      |> Integer.digits()
      |> Enum.reduce(
        %{last: Enum.at(Integer.digits(number), 0), list: []},
        &is_less_than_previous?(&1, &2)
      )

    length(Integer.digits(number)) == length(consec.list)
  end

  def is_less_than_previous?(x, %{last: y, list: acc}) do
    if y <= x do
      %{last: x, list: [x | acc]}
    else
      %{last: x, list: acc}
    end
  end

  def part2() do
    256_310..732_736
    |> Enum.filter(&has_atleast_one_double?(&1))
    |> Enum.filter(&has_consecutive_digits?(&1))
    |> Enum.count()
  end
end
