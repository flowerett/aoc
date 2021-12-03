defmodule Day7 do
  @moduledoc """
  Documentation for Day7.

  Not finished or solution lost
  """

  @input """
  Step C must be finished before step A can begin.
  Step C must be finished before step F can begin.
  Step A must be finished before step B can begin.
  Step A must be finished before step D can begin.
  Step B must be finished before step E can begin.
  Step D must be finished before step E can begin.
  Step F must be finished before step E can begin.
  """

  def prep_data, do: File.read!("../inputs/day7")

  @doc """
  Parse order instructions.

  ## Examples

    iex> Day7.get_steps()
    [
      {"C", "A"},
      {"C", "F"},
      {"A", "B"},
      {"A", "D"},
      {"B", "E"},
      {"D", "E"},
      {"F", "E"}
    ]
  """
  def get_steps(data \\ @input) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&InputParser.steps/1)
  end

  @doc """
  plan:
  [C, A]
  [C, [A, F]]
  [C, [A, [B, F]]]
  [C, [A, [B, D, F]]]
  [C, [A, [B, [D, E, F]]]]
  [C, [A, [B, [D, [E, E, F]]]]] => [C [A, [B, [D, [E, F]]]]]
  [C, [A, [B, [D, [E, F]]]]] => [C, [A, [B, [D, [F, E]]]]]


  ["C", ["A", ["B", ["D", ["E", "E", "F"]]]]]

  [?C, [?A, [?B, [?D, [?F, ?E]]]]]
  "CABDFE"

    iex> steps = Day7.get_steps()
    iex> Day7.order_steps(steps)
    "CABDFE"
  """
  def order_steps(steps) do
    steps
    |> Enum.reduce([], fn {first, last}, acc ->
      put_instruction({first, last}, acc)
    end)
    |> List.to_string()
  end

  @doc """
  ## Examples

    iex> Day7.put_instruction({"C", "A"}, [])
    ["C", "A"]
  """
  def put_instruction({first, last}, acc) when length(acc) == 0 do
    IO.puts("=== EMPTY ACC")
    [first, last]
  end

  @doc """
  ## Examples

    iex> Day7.put_instruction({"C", "R"}, "C")
    ["C", ["R"]]
  """
  def put_instruction({first, last}, single) when is_binary(single) and first == single do
    IO.puts("======== SINGLE")
    [first, [last]]
  end

  @doc """
  ## Examples

    iex> Day7.put_instruction({"C", "F"}, ["C", "A"])
    ["C", ["A", "F"]]
  """
  def put_instruction({first, last}, [start | rest]) when first == start do
    IO.puts("FIRST, LAST, START, REST (FIRST == START)")

    case List.flatten(rest) == rest do
      false ->
        [rest] = rest
        put_inside_list(first, last, rest)

      true ->
        put_inside_list(first, last, rest)
    end
  end

  @doc """
  ## Examples

    iex> Day7.put_instruction({"A", "B"}, ["C", ["A", "F"]])
    ["C", ["A", ["B", "F"]]]

    iex> Day7.put_instruction({"A", "D"}, ["C", ["A", ["B", "F"]]])
    ["C", ["A", ["B", "D", "F"]]]

    iex> Day7.put_instruction({"C", "R"}, ["S", "C"])
    ["S", ["C", ["R"]]]
  """
  def put_instruction({first, last}, [start | rest]) do
    [rest] = rest

    IO.puts("inserting " <> inspect({first, last}))
    IO.puts("into " <> inspect([start, rest]))
    IO.puts("============ RECURSION")

    if [first, last] == [rest, start] do
      [first, last]
    else
      tail = put_instruction({first, last}, rest)
      [start, tail]
    end
  end

  defp put_inside_list(first, last, rest) do
    if Enum.any?(rest, &(&1 == last)) do
      [first, rest]
    else
      [first, [last | rest] |> Enum.reverse() |> Enum.sort()]
    end
  end

  def task1() do
    prep_data()
    |> get_steps()
    |> order_steps()
  end
end

defmodule InputParser do
  import NimbleParsec

  def steps(string) when is_binary(string) do
    {:ok, [first, last], "", _, _, _} = parse_steps(string)
    {first, last}
  end

  defparsec(
    :parse_steps,
    ignore(string("Step "))
    # |> ascii_char([?A..?Z])
    |> ascii_string([?A..?Z], 1)
    |> ignore(string(" must be finished before step "))
    # |> ascii_char([?A..?Z])
    |> ascii_string([?A..?Z], 1)
    |> ignore(string(" can begin."))
  )
end
