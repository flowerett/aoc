defmodule Adv.Day1 do
  @input "../inputs/day1"
  @test_input [12, 14, 1969, 100_756]
  # test_output [2, 2, 654, 100_756]

  use Adv, input: @input, transform: &String.to_integer/1

  @doc ~S"""
  Get total mass from input

  ## Examples

    iex> solve1()
    34241

    iex> input() |> solve1()
    3502510
  """
  def solve1(input \\ @test_input) do
    input
    |> Enum.map(&calc_fuel/1)
    |> Enum.sum()
  end

  @doc ~S"""
  Get total mass with fuel

  ## Examples

    iex> solve2()
    51316

    iex> input() |> solve2()
    5250885
  """
  def solve2(input \\ @test_input) do
    input
    |> Enum.map(&calc_total_fuel(0, &1))
    |> Enum.sum()
  end

  defp calc_fuel(mass) do
    div(mass, 3)
    |> Kernel.-(2)
  end

  defp calc_total_fuel(total, mass) do
    case calc_fuel(mass) do
      mass when mass > 0 ->
        calc_total_fuel(total + mass, mass)

      _ ->
        total
    end
  end
end
