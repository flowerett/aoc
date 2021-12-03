defmodule Day1 do
  def get_input do
    "inputs/day1"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  def get_sum(input), do: Enum.sum(input)

  def get_freq_delta(input) do
    init_acc = %{total: 0, count: 0, seen: MapSet.new(), bingo: nil}

    input
    |> Stream.cycle()
    |> Enum.reduce_while(init_acc, fn delta, acc ->
      seen = acc[:seen]
      total = acc[:total] + delta
      count = acc[:count] + 1

      if MapSet.member?(seen, total) do
        {:halt, %{acc | bingo: total}}
      else
        {:cont, %{acc | total: total, count: count, seen: MapSet.put(seen, total)}}
      end
    end)
  end
end

inp = Day1.get_input()
inp |> Day1.get_sum() |> IO.inspect(label: "res1")
inp |> Day1.get_freq_delta() |> IO.inspect(label: "res2")
