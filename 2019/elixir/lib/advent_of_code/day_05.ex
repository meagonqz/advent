defmodule AdventOfCode.Day05 do
  require Integer
  @first_input 1
  @second_input 5

  def process_sequence(input, first, return_at_output \\ false) do
    process(input, 0, first, return_at_output)
  end

  def peek_opcode(opcode) do
    List.last(opcode)
  end

  def process(input, index, inputs, return_at_output) do
    opcode = Enum.at(input, index)
    op = peek_opcode(Integer.digits(opcode))

    process_opcode(op, input, index, inputs, return_at_output)
  end

  # input, 3, 50 -> takes input value and stores it at 50
  def process_opcode(3, input, index, [initial | rest], return) do
    opcode_length = 2
    [3, address] = Enum.slice(input, index..(index + 1)) |> Enum.take(opcode_length)
    process(List.replace_at(input, address, initial), index + opcode_length, rest, return)
  end

  def process_opcode(4, input, index, inputs, return) do
    opcode_length = 2
    [four, address] = Enum.slice(input, index..(index + opcode_length - 1))
    [mode, _zero, 4] = pad_digit_values(four, 3)
    value = get_value(address, mode, input)

    if return do
      value
    else
      IO.inspect(return, label: "Output")
      process(input, index + opcode_length, inputs, return)
    end
  end

  # input [1, 2, 3, 4], 2 + 3, store in 4
  def process_opcode(1, input, index, inputs, return) do
    opcode_length = 4
    [one, i, i2, result] = Enum.slice(input, index..(index + opcode_length - 1))
    padded = pad_digit_values(one)
    input = process_by_mode(padded, [i, i2, result], input, &Kernel.+/2)
    process(input, index + opcode_length, inputs, return)
  end

  # input [2, 3, 4, 5], 3 * 4, store in 5
  def process_opcode(2, input, index, inputs, return) do
    opcode_length = 4
    [one, i, i2, result] = Enum.slice(input, index..(index + opcode_length - 1))
    padded = pad_digit_values(one)
    input = process_by_mode(padded, [i, i2, result], input, &Kernel.*/2)
    process(input, index + opcode_length, inputs, return)
  end

  # input [5, 6, 7] jump instructions to value if 6 is non-zero
  def process_opcode(5, input, index, inputs, return) do
    opcode_length = 3
    [five, i, i2] = Enum.slice(input, index..(index + opcode_length - 1))
    [input_2_mode, input_1_mode, 0, 5] = pad_digit_values(five, 4)
    value = get_value(i, input_1_mode, input)
    value2 = get_value(i2, input_2_mode, input)

    if value != 0 do
      process(input, value2, inputs, return)
    else
      process(input, index + opcode_length, inputs, return)
    end
  end

  # jump instructions to value if i is zero
  def process_opcode(6, input, index, inputs, return) do
    opcode_length = 3
    [six, i, i2] = Enum.slice(input, index..(index + opcode_length - 1))
    [input_2_mode, input_1_mode, 0, 6] = pad_digit_values(six, 4)
    value = get_value(i, input_1_mode, input)
    value2 = get_value(i2, input_2_mode, input)

    if value == 0 do
      process(input, value2, inputs, return)
    else
      process(input, index + opcode_length, inputs, return)
    end
  end

  # input [7, 8, 9, 10] if 8 is less than 9, store 1 in 10
  def process_opcode(7, input, index, inputs, return) do
    opcode_length = 4
    [seven, i, i2, result] = Enum.slice(input, index..(index + opcode_length - 1))
    [_result_mode, input_2_mode, input_1_mode, 0, 7] = pad_digit_values(seven)
    value = get_value(i, input_1_mode, input)
    value2 = get_value(i2, input_2_mode, input)

    if(value < value2) do
      input = List.replace_at(input, result, 1)
      process(input, index + opcode_length, inputs, return)
    else
      input = List.replace_at(input, result, 0)
      process(input, index + opcode_length, inputs, return)
    end
  end

  def process_opcode(8, input, index, inputs, return) do
    opcode_length = 4
    [eight, i, i2, result] = Enum.slice(input, index..(index + opcode_length - 1))
    [_result_mode, input_2_mode, input_1_mode, 0, 8] = pad_digit_values(eight)
    value = get_value(i, input_1_mode, input)
    value2 = get_value(i2, input_2_mode, input)

    if(value == value2) do
      input = List.replace_at(input, result, 1)
      process(input, index + opcode_length, inputs, return)
    else
      input = List.replace_at(input, result, 0)
      process(input, index + opcode_length, inputs, return)
    end
  end

  def process_opcode(9, input, index, _inputs, _return) do
    opcode_length = 2
    [99, value] = Enum.slice(input, index..(index + opcode_length - 1))
    IO.inspect(value, label: "99 output")
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
    |> process_sequence([@first_input])
  end

  def part2() do
    "assets/day05_input.txt"
    |> AdventOfCode.read_file()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> process_sequence([@second_input])
  end
end
