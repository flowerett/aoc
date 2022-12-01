tdata = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

# data = File.read!("../inputs/day1")

sums =
  tdata
  |> String.split("\n\n")
  |> Enum.map(fn block ->
    block
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end)

r1 = Enum.max(sums)
r2 = sums |> Enum.sort(:desc) |> Enum.take(3) |> Enum.sum()

IO.puts("Res1: #{r1}")
IO.puts("Res2: #{r2}")
