defmodule AdventOfCode.CPU do
  alias __MODULE__
  defstruct memory: nil, index: nil, state: :unitialized, inputs: [], output: [], downstream: nil

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
      memory: memory,
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
    List.last(opcode)
  end

  def process(%CPU{memory: memory, index: index} = cpu) do
    opcode = Enum.at(memory, index)
    op = peek_opcode(Integer.digits(opcode))

    process_opcode(op, cpu)
  end

  # input, 3, 50 -> takes input value and stores it at 50
  def process_opcode(3, %CPU{memory: memory, index: index} = cpu) do
    value =
      receive do
        x -> x
      end

    opcode_length = 2
    [3, address] = Enum.slice(memory, index..(index + 1)) |> Enum.take(opcode_length)

    process(%CPU{
      cpu
      | memory: List.replace_at(memory, address, value),
        index: index + opcode_length,
        inputs: [value | cpu.inputs]
    })
  end

  def process_opcode(
        4,
        %CPU{memory: memory, index: index, output: output, downstream: downstream} = cpu
      ) do
    opcode_length = 2
    [four, address] = Enum.slice(memory, index..(index + opcode_length - 1))
    [mode, _zero, 4] = pad_digit_values(four, 3)
    value = get_value(address, mode, memory)

    if downstream do
      send(downstream, value)
      process(%CPU{cpu | output: value, index: index + opcode_length, state: :waiting})
    else
      IO.inspect(value)
      process(%CPU{cpu | state: :waiting, index: index + opcode_length, output: [value, output]})
    end
  end

  # input [1, 2, 3, 4], 2 + 3, store in 4
  def process_opcode(1, %CPU{memory: memory, index: index} = cpu) do
    opcode_length = 4
    [one, i, i2, result] = Enum.slice(memory, index..(index + opcode_length - 1))
    padded = pad_digit_values(one)
    memory = process_by_mode(padded, [i, i2, result], memory, &Kernel.+/2)
    process(%CPU{cpu | memory: memory, index: index + opcode_length})
  end

  # input [2, 3, 4, 5], 3 * 4, store in 5
  def process_opcode(2, %CPU{memory: memory, index: index} = cpu) do
    opcode_length = 4
    [one, i, i2, result] = Enum.slice(memory, index..(index + opcode_length - 1))
    padded = pad_digit_values(one)
    memory = process_by_mode(padded, [i, i2, result], memory, &Kernel.*/2)
    process(%CPU{cpu | memory: memory, index: index + opcode_length})
  end

  # input [5, 6, 7] jump instructions to value if 6 is non-zero
  def process_opcode(5, %CPU{memory: memory, index: index} = cpu) do
    opcode_length = 3
    [five, i, i2] = Enum.slice(memory, index..(index + opcode_length - 1))
    [input_2_mode, input_1_mode, 0, 5] = pad_digit_values(five, 4)
    value = get_value(i, input_1_mode, memory)
    value2 = get_value(i2, input_2_mode, memory)

    if value != 0 do
      process(%CPU{cpu | memory: memory, index: value2})
    else
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    end
  end

  # jump instructions to value if i is zero
  def process_opcode(6, %CPU{memory: memory, index: index} = cpu) do
    opcode_length = 3
    [six, i, i2] = Enum.slice(memory, index..(index + opcode_length - 1))
    [input_2_mode, input_1_mode, 0, 6] = pad_digit_values(six, 4)
    value = get_value(i, input_1_mode, memory)
    value2 = get_value(i2, input_2_mode, memory)

    if value == 0 do
      process(%CPU{cpu | memory: memory, index: value2})
    else
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    end
  end

  # input [7, 8, 9, 10] if 8 is less than 9, store 1 in 10
  def process_opcode(7, %CPU{memory: memory, index: index} = cpu) do
    opcode_length = 4
    [seven, i, i2, result] = Enum.slice(memory, index..(index + opcode_length - 1))
    [_result_mode, input_2_mode, input_1_mode, 0, 7] = pad_digit_values(seven)
    value = get_value(i, input_1_mode, memory)
    value2 = get_value(i2, input_2_mode, memory)

    if(value < value2) do
      memory = List.replace_at(memory, result, 1)
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    else
      memory = List.replace_at(memory, result, 0)
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    end
  end

  def process_opcode(8, %CPU{memory: memory, index: index} = cpu) do
    opcode_length = 4
    [eight, i, i2, result] = Enum.slice(memory, index..(index + opcode_length - 1))
    [_result_mode, input_2_mode, input_1_mode, 0, 8] = pad_digit_values(eight)
    value = get_value(i, input_1_mode, memory)
    value2 = get_value(i2, input_2_mode, memory)

    if(value == value2) do
      memory = List.replace_at(memory, result, 1)
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    else
      memory = List.replace_at(memory, result, 0)
      process(%CPU{cpu | memory: memory, index: index + opcode_length})
    end
  end

  def process_opcode(9, %CPU{} = cpu) do
    {:ok, %CPU{cpu | state: :halted}}
  end

  def pad_digit_values(value, padding \\ 5) do
    digits = Integer.digits(value)
    len = length(digits)
    padding = [0] |> Stream.cycle() |> Enum.take(padding - len)
    padding ++ digits
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
end
