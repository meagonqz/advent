defmodule AdventOfCode.Day07 do
  alias AdventOfCode.CPU
  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

  def part1() do
    [4, 3, 2, 1, 0]
    |> permutations()
    |> run_phases()
  end

  def run_phases(phases) do
    phases
    |> Enum.map(&scan_each_phase(&1))
    |> Enum.map(&Enum.to_list/1)
    |> IO.inspect()
    |> Enum.map(&Enum.drop(&1, 4))
    |> List.flatten()
    |> Enum.max()
  end

  def scan_each_phase(sequence) do
    Stream.scan(sequence, 0, &process_phase(&1, &2))
  end

  def input() do
    "assets/day07_input.txt"
    |> AdventOfCode.read_file()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def process_phase(phase, input) do
    "assets/day07_input.txt"
    |> AdventOfCode.read_file()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> process_sequence(phase, input)
  end

  def process_sequence(puzzle_input, phase, input) do
    AdventOfCode.Day05.process_sequence(puzzle_input, [phase, input], %{
      return_at_output: true,
      downstream: nil
    })
  end

  def test() do
    input =
      "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    Stream.scan([4, 3, 2, 1, 0], 0, &process_sequence(input, &1, &2))
    |> Enum.to_list()
    |> Enum.map(&Enum.at(&1, 0))
    |> IO.inspect()
  end

  def part22() do
    puzzle_input = input()

    [5, 6, 7, 8, 9]
    |> permutations()
    |> IO.inspect()
    |> Enum.map(&run_programs(&1, puzzle_input))
    |> Enum.max_by(fn {_, result} -> result end)
  end

  def part2() do
    puzzle_input = input()

    [5, 6, 7, 8, 9]
    |> permutations
    |> Enum.map(&run_programs(&1, puzzle_input))
    |> Enum.max_by(fn {_, result} -> result end)
  end

  def run_programs([phase_a, phase_b, phase_c, phase_d, phase_e] = perm, puzzle_input) do
    me = self()
    b_pid = String.to_atom("#{perm}b")

    a =
      spawn(fn ->
        CPU.process_sequence(CPU.new(%{memory: puzzle_input, downstream: b_pid}))
      end)

    e =
      spawn(fn ->
        {:ok, %CPU{output: output}} =
          CPU.process_sequence(CPU.new(%{memory: puzzle_input, downstream: a}))

        send(me, output)
      end)

    d =
      spawn(fn ->
        CPU.process_sequence(CPU.new(%{memory: puzzle_input, downstream: e}))
      end)

    c =
      spawn(fn ->
        CPU.process_sequence(CPU.new(%{memory: puzzle_input, downstream: d}))
      end)

    b =
      spawn(fn ->
        Process.register(self(), b_pid)
        CPU.process_sequence(CPU.new(%{memory: puzzle_input, downstream: c}))
      end)

    :timer.sleep(100)

    send(a, phase_a)
    send(b, phase_b)
    send(c, phase_c)
    send(d, phase_d)
    send(e, phase_e)

    send(a, 0)

    receive do
      out ->
        {perm, out}
    end
  end
end
