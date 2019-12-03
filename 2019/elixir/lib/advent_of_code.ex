defmodule AdventOfCode do
  @moduledoc """
  Documentation for AdventOfCode.
  """
  def read_file(args) do
    case File.read(args) do
      {:ok, input} -> input
      {:error, reason} -> IO.inspect(reason, label: "Error reading file: ")
    end
  end

  def parse_input_as_integers(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
