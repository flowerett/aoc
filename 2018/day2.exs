defmodule Day2 do
  @test_input [
    "abcde",
    "fghij",
    "klmno",
    "pqrst",
    "fguij",
    "axcye",
    "wvxyz"
  ]

  def get_input do
    "inputs/day2"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def search_id(input \\ @test_input) do
    [term | tail] = input

    case check_list(term, tail) do
      nil -> search_id(tail)
      id -> id
    end
  end

  def check_list(term, list) do
    list
    |> Enum.reduce_while(nil, fn row, acc ->
      case check_combination(term, row) do
        nil -> {:cont, acc}
        id -> {:halt, id}
      end
    end)
  end

  def check_combination(a, b) do
    list_a = a |> String.graphemes()
    list_b = b |> String.graphemes()

    delta =
      Enum.zip(list_a, list_b)
      |> Enum.map(fn {a, b} -> if a == b, do: a end)
      |> Enum.filter(&(!is_nil(&1)))

    if length(delta) == length(list_a) - 1, do: List.to_string(delta)
  end
end

inp = Day2.get_input()
inp |> Day2.search_id() |> IO.inspect(label: "res2")
