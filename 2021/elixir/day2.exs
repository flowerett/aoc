# day 2 is much more fun with functional programming

defmodule Day2 do
  def parse_all(fname) do
    fname
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse/1)
  end

  def task1({:u, val}, acc), do: Map.update!(acc, :v, &(&1 - val))
  def task1({:d, val}, acc), do: Map.update!(acc, :v, &(&1 + val))
  def task1({:f, val}, acc), do: Map.update!(acc, :h, &(&1 + val))

  def task2({:u, val}, acc), do: Map.update!(acc, :aim, &(&1 - val))
  def task2({:d, val}, acc), do: Map.update!(acc, :aim, &(&1 + val))

  def task2({:f, val}, acc) do
    acc = Map.update!(acc, :h, &(&1 + val))
    Map.update!(acc, :v, &(&1 + val * acc.aim))
  end

  defp parse(<<"forward ", val::binary>>), do: {:f, to_i(val)}
  defp parse(<<"up ", val::binary>>), do: {:u, to_i(val)}
  defp parse(<<"down ", val::binary>>), do: {:d, to_i(val)}

  defp to_i(string), do: String.to_integer(string)
end

input = "../inputs/day2t"
# input = "../inputs/day2"

# task 1
input
|> Day2.parse_all()
|> Enum.reduce(%{v: 0, h: 0}, &Day2.task1/2)
|> Map.values()
|> Enum.product()
|> IO.inspect(label: "res1")

# task 2
input
|> Day2.parse_all()
|> Enum.reduce(%{v: 0, h: 0, aim: 0}, &Day2.task2/2)
|> Map.take([:h, :v])
|> Map.values()
|> Enum.product()
|> IO.inspect(label: "res2")
