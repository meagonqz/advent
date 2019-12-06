defmodule AdventOfCode.Day05 do
  require Integer
  @opcode_length 2
  @initial_input 1

  def process_sequence(input) do
    process(input, 0)
  end

  def peek_opcode(opcode) do
    List.last(opcode)
  end

  def process(input, index) do
    opcode = Enum.at(input, index)
    op = peek_opcode(Integer.digits(opcode))
    process_opcode(op, input, index)
  end

  # input, 3, 50 -> takes input value and stores it at 50
  def process_opcode(3, input, index) do
    opcode_length = 2
    [3, address] = Enum.take(input, opcode_length)
    process(List.replace_at(input, address, @initial_input), index + opcode_length)
  end

  def process_opcode(4, input, index) do
    opcode_length = 2
    [four, address] = Enum.slice(input, index..(index + opcode_length - 1))
    [mode, _zero, 4] = pad_digit_values(four, 3)
    value = get_value(address, mode, input)
    IO.inspect(value, label: "Output!")
    process(input, index + opcode_length)
  end

  # input [1, 2, 3, 4], 2 + 3, store in 4
  def process_opcode(1, input, index) do
    opcode_length = 4
    [one, i, i2, result] = Enum.slice(input, index..(index + opcode_length - 1))
    padded = pad_digit_values(one)
    input = process_by_mode(padded, [i, i2, result], input, &Kernel.+/2)
    process(input, index + opcode_length)
  end

  # input [2, 3, 4, 5], 3 * 4, store in 5
  def process_opcode(2, input, index) do
    opcode_length = 4
    [one, i, i2, result] = Enum.slice(input, index..(index + opcode_length - 1))
    padded = pad_digit_values(one)
    input = process_by_mode(padded, [i, i2, result], input, &Kernel.*/2)
    process(input, index + opcode_length)
  end

  def process_opcode(9, input, index) do
    opcode_length = 2
    [99, value] = Enum.slice(input, index..(index + opcode_length - 1))
    IO.inspect(value)
  end

  def boolean_to_integer(true), do: 1
  def boolean_to_integer(false), do: 0

  def pad_digit_values(value, padding \\ 5) do
    digits = Integer.digits(value)
    len = length(digits)
    padding = [0] |> Stream.cycle() |> Enum.take(padding - len)
    padding ++ digits
  end

  def pad_value(value, params \\ 5) do
    len = length(value)
    padding = [0] |> Stream.cycle() |> Enum.take(params - len)
    padding ++ value
  end

  def process_by_mode(
        [0, input_2_mode, input_1_mode, 0, _opcode],
        [i, i2, result],
        input,
        operation
      ) do
    first = get_value(i, input_1_mode, input)
    second = get_value(i2, input_2_mode, input)
    result_value = operation.(first, second)

    List.replace_at(input, result, result_value)
  end

  def get_value(i, 1, _input) do
    i
  end

  def get_value(i, 0, input) do
    Enum.at(input, i)
  end

  def part1() do
    "assets/day05_input.txt"
    |> AdventOfCode.read_file()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> process_sequence()
  end

  def part2() do
  end
end
