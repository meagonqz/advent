defmodule AdventOfCode.CPU do
  alias __MODULE__

  defstruct memory: nil,
            index: nil,
            relative: 0,
            state: :unitialized,
            inputs: [],
            output: [],
            downstream: nil

  @type state :: :unitialized | :ready | :running | :waiting | :halted
  @type t :: %__MODULE__{
          memory: list(integer),
          state: state(),
          inputs: list(integer()),
          output: list(integer())
        }

  @spec new(Enum.t()) :: t
  def new(%{memory: memory, downstream: downstream}) do
    %__MODULE__{
      memory: memory ++ List.duplicate(0, length(memory) * 2),
      downstream: downstream,
      state: :ready,
      index: 0
    }
  end

  def process_sequence(%CPU{state: :halted} = cpu) do
    {:ok, cpu}
  end

  def process_sequence(%CPU{} = cpu) do
    process(%CPU{cpu | state: :running})
  end

  def peek_opcode(opcode) do
    op_length = length(opcode)

    if(Enum.slice(opcode, (op_length - 2)..(op_length - 1)) == [9, 9]) do
      99
    else
      List.last(opcode)
    end
  end

  def process(%CPU{memory: memory, index: index} = cpu) do
    opcode = Enum.at(memory, index)
    op = peek_opcode(Integer.digits(opcode))

    process_opcode(op, cpu)
  end

  # input, 3, 50 -> takes input value and stores it at 50
  def process_opcode(
        3,
        %CPU{memory: memory, index: index, relative: relative} = cpu
      ) do
    value =
      receive do
        x -> x
      end

    opcode_length = 2
    [three, address] = Enum.slice(memory, index..(index + 1)) |> Enum.take(opcode_length)
    [mode, _zero, 3] = pad_digit_values(three, 3)
    address = address_if_relative(mode, address, relative)

    process(%CPU{
      cpu
      | memory: List.replace_at(memory, address, value),
        index: index + opcode_length,
        inputs: [value | cpu.inputs]
    })
  end

  def process_opcode(
        4,
        %CPU{
          memory: memory,
          relative: relative,
          index: index,
          output: output,
          downstream: downstream
        } = cpu
      ) do
    opcode_length = 2
    [four, address] = Enum.slice(memory, index..(index + opcode_length - 1))
    [mode, _zero, 4] = pad_digit_values(four, 3)
    value = get_value(address, mode, memory, relative)

    if downstream do
      send(downstream, value)
      process(%CPU{cpu | output: value, index: index + opcode_length, state: :waiting})
    else
      IO.inspect(value)
      process(%CPU{cpu | state: :waiting, index: index + opcode_length, output: [value, output]})
    end
  end

  # input [1, 2, 3, 4], 2 + 3, store in 4
  def process_opcode(1, %CPU{memory: memory, index: index, relative: relative} = cpu) do
    opcode_length = 4
    [one, i, i2, result] = Enum.slice(memory, index..(index + opcode_length - 1))
    padded = pad_digit_values(one)
    memory = process_by_mode(padded, [i, i2, result], memory, relative, &Kernel.+/2)
    process(%CPU{cpu | memory: memory, index: index + opcode_length})
  end

  # input [2, 3, 4, 5], 3 * 4, store in 5
  def process_opcode(2, %CPU{memory: memory, index: index, relative: relative} = cpu) do
    opcode_length = 4
    [one, i, i2, result] = Enum.slice(memory, index..(index + opcode_length - 1))
    padded = pad_digit_values(one)
    memory = process_by_mode(padded, [i, i2, result], memory, relative, &Kernel.*/2)
    process(%CPU{cpu | memory: memory, index: index + opcode_length})
  end

  # input [5, 6, 7] jump instructions to value if 6 is non-zero
  def process_opcode(5, %CPU{memory: memory, index: index, relative: relative} = cpu) do
    opcode_length = 3
    [five, i, i2] = Enum.slice(memory, index..(index + opcode_length - 1))
    [input_2_mode, input_1_mode, 0, 5] = pad_digit_values(five, 4)
    value = get_value(i, input_1_mode, memory, relative)
    value2 = get_value(i2, input_2_mode, memory, relative)

    if value != 0 do
      process(%CPU{cpu | memory: memory, index: value2})
    else
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    end
  end

  # jump instructions to value if i is zero
  def process_opcode(6, %CPU{memory: memory, index: index, relative: relative} = cpu) do
    opcode_length = 3
    [six, i, i2] = Enum.slice(memory, index..(index + opcode_length - 1))
    [input_2_mode, input_1_mode, 0, 6] = pad_digit_values(six, 4)
    value = get_value(i, input_1_mode, memory, relative)
    value2 = get_value(i2, input_2_mode, memory, relative)

    if value == 0 do
      process(%CPU{cpu | memory: memory, index: value2})
    else
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    end
  end

  # input [7, 8, 9, 10] if 8 is less than 9, store 1 in 10
  def process_opcode(7, %CPU{memory: memory, index: index, relative: relative} = cpu) do
    opcode_length = 4
    [seven, i, i2, result] = Enum.slice(memory, index..(index + opcode_length - 1))
    [result_mode, input_2_mode, input_1_mode, 0, 7] = pad_digit_values(seven)
    value = get_value(i, input_1_mode, memory, relative)
    value2 = get_value(i2, input_2_mode, memory, relative)
    address = address_if_relative(result_mode, result, relative)

    if(value < value2) do
      memory = List.replace_at(memory, address, 1)
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    else
      memory = List.replace_at(memory, address, 0)
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    end
  end

  def process_opcode(8, %CPU{memory: memory, index: index, relative: relative} = cpu) do
    opcode_length = 4
    [eight, i, i2, result] = Enum.slice(memory, index..(index + opcode_length - 1))
    [result_mode, input_2_mode, input_1_mode, 0, 8] = pad_digit_values(eight)
    value = get_value(i, input_1_mode, memory, relative)
    value2 = get_value(i2, input_2_mode, memory, relative)
    address = address_if_relative(result_mode, 0, relative)

    if(value == value2) do
      memory = List.replace_at(memory, result, 1 + address)
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    else
      memory = List.replace_at(memory, result, 0 + address)
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    end
  end

  def process_opcode(9, %CPU{memory: memory, index: index, relative: relative} = cpu) do
    opcode_length = 2
    [nine, address] = Enum.slice(memory, index..(index + opcode_length - 1))
    [mode, _zero, 9] = pad_digit_values(nine, 3)
    value = get_value(address, mode, memory, relative)
    process(%CPU{cpu | relative: value + relative, index: index + opcode_length})
  end

  def process_opcode(99, %CPU{} = cpu) do
    {:ok, %CPU{cpu | state: :halted}}
  end

  def address_if_relative(mode, address, relative) do
    if mode == 2, do: address + relative, else: address
  end

  def pad_digit_values(value, padding \\ 5) do
    digits = Integer.digits(value)
    len = length(digits)
    padding = [0] |> Stream.cycle() |> Enum.take(padding - len)
    padding ++ digits
  end

  def process_by_mode(
        [address_mode, input_2_mode, input_1_mode, 0, _opcode],
        [i, i2, result],
        input,
        relative,
        operation
      ) do
    first = get_value(i, input_1_mode, input, relative)
    second = get_value(i2, input_2_mode, input, relative)
    address = address_if_relative(address_mode, result, relative)
    result_value = operation.(first, second)

    List.replace_at(input, address, result_value)
  end

  def get_value(i, 1, _input, _relative) do
    i
  end

  def get_value(i, 0, input, _relative) do
    Enum.at(input, i)
  end

  def get_value(i, 2, input, relative) do
    Enum.at(input, i + relative)
  end
end
