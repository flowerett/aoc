defmodule Adv.Day2 do
  @input "../inputs/day2"

  alias __MODULE__

  use Adv,
    input: @input,
    transform: &Day2.transform/1,
    post: &List.flatten/1

  def transform(row) do
    row
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  @test_input [1, 0, 0, 0, 99]
  # @test2 [2, 3, 0, 3, 99]
  # @test3 [2, 4, 4, 5, 99, 0]
  # @test4 [1, 1, 1, 4, 99, 5, 6, 0, 99]
  # @test5 [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]

  @doc ~S"""
    iex> solve1()
    [2,0,0,0,99]

    iex> solve1 [2, 3, 0, 3, 99]
    [2,3,0,6,99]

    iex> solve1 [2, 4, 4, 5, 99, 0]
    [2,4,4,5,99,9801]

    iex> solve1 [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]
    [3500,9,10,70,2,3,11,0,99,30,40,50]

    iex> solve1 [1, 1, 1, 4, 99, 5, 6, 0, 99]
    [30,1,1,4,2,5,6,0,99]
  """
  def solve1(input \\ @test_input) do
    process(input, 0)
  end

  @doc ~S"""
    iex> input() |> solve_p1()
    7210630
  """
  def solve_p1(input, v \\ 12, n \\ 2) do
    input
    |> set_init(v, n)
    |> process(0)
    |> List.first()
  end

  @doc ~S"""
    With terminology out of the way, we're ready to proceed.
    To complete the gravity assist, you need to determine what pair of inputs produces the output 19690720.

    # Example
    iex> input() |> solve_p2()
    {38,92,3892}
  """
  def solve_p2(input) do
    try do
      for v <- 0..99,
          n <- 0..99 do
        case solve_p1(input, v, n) do
          19_690_720 ->
            throw({v, n, v * 100 + n})

          _ ->
            nil
        end
      end
    catch
      res -> res
    end
  end

  def set_init(input, v, n) do
    input
    |> List.replace_at(1, v)
    |> List.replace_at(2, n)
  end

  def process(acc, idx) do
    {processed, rest} = Enum.split(acc, idx + 1)
    cmd = List.last(processed)

    run(cmd, acc, rest, idx + 1)
  end

  def run(1, acc, cmd, idx) do
    [x, y, adr | _rest] = cmd
    new_v = Enum.at(acc, x) + Enum.at(acc, y)

    acc
    |> List.replace_at(adr, new_v)
    |> process(idx + 3)
  end

  def run(2, acc, cmd, idx) do
    [x, y, adr | _rest] = cmd
    new_v = Enum.at(acc, x) * Enum.at(acc, y)

    acc
    |> List.replace_at(adr, new_v)
    |> process(idx + 3)
  end

  def run(99, acc, _cmd, _idx), do: acc

  def run(_, acc, _cmd, _idx), do: acc
end
