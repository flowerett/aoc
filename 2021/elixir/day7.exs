defmodule Day7 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def t1(pos, cur, memo), do: {abs(pos - cur), memo}

  def t2(pos, cur, memo) do
    {dd, _} = t1(pos, cur, nil)

    unless Map.has_key?(memo, dd) do
      sum = Enum.reduce(0..dd, 0, &+/2)
      new_memo = Map.put(memo, dd, sum)

      {new_memo[dd], new_memo}
    else
      {memo[dd], memo}
    end
  end

  def total_fuel(data, memo, pos, fun) do
    Enum.reduce(data, {0, memo}, fn cur, {sum, memo} ->
      {cfuel, memo} = fun.(pos, cur, memo)
      {sum + cfuel, memo}
    end)
  end

  def find_min_fuel(data, fun) do
    {min, max} = Enum.min_max(data)

    min..max
    |> Enum.reduce({0, nil, %{}}, fn pos, {pmin, fmin, memo} ->
      {fuel, memo} = total_fuel(data, memo, pos, fun)

      if is_nil(fmin) or fuel < fmin do
        {pos, fuel, memo}
      else
        {pmin, fmin, memo}
      end
    end)
  end
end

input = """
16,1,2,0,4,2,7,1,2,14
"""

data = Day7.parse_input(input)
# data = "../inputs/day7" |> File.read!() |> Day7.parse_input()

{pmin1, fmin1, _m} = Day7.find_min_fuel(data, &Day7.t1/3)
{pmin2, fmin2, _m} = Day7.find_min_fuel(data, &Day7.t2/3)

IO.puts("res1: (#{pmin1}) #{fmin1}")
IO.puts("res2: (#{pmin2}) #{fmin2}")
