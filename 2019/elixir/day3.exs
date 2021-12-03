defmodule Day3 do
  def parse_all(input) do
    input
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&parse_row/1)
  end

  def parse_row(row), do: Enum.reduce(row, {0, 0, 0, []}, &parse_comm/2)

  def parse_comm(comm, {x, y, dist, wires}) do
    {xx, yy, len} = move(comm, x, y)
    wire = {x, y, xx, yy, dist}
    {xx, yy, dist + len, [wire | wires]}
  end

  def move(<<?U, v::binary>>, x, y) do
    len = String.to_integer(v)
    {x, y + len, len}
  end

  def move(<<?D, v::binary>>, x, y) do
    len = String.to_integer(v)
    {x, y - len, len}
  end

  def move(<<?L, v::binary>>, x, y) do
    len = String.to_integer(v)
    {x - len, y, len}
  end

  def move(<<?R, v::binary>>, x, y) do
    len = String.to_integer(v)
    {x + len, y, len}
  end

  def intersections(w1, w2) do
    for v1 <- w1, v2 <- w2 do
      find_intersection(v1, v2)
    end
    |> Enum.reject(&is_nil/1)
    |> Enum.reject(&(&1 == {0, 0, 0, 0}))
  end

  # first - horizontal, second - vertical
  # first delta  - x11 -> x2
  # second delta - y21 -> y1
  def find_intersection({x11, y1, x12, y1, d1}, {x2, y21, x2, y22, d2})
      when x2 in x11..x12 and y1 in y21..y22 do
    {x2, y1, d1 + delta(x2, x11), d2 + delta(y1, y21)}
  end

  # first - vertical, second - horizontal
  # first delta  - y11 -> y2
  # second delta - x21 -> x1
  def find_intersection({x1, y11, x1, y12, d1}, {x21, y2, x22, y2, d2})
      when x1 in x21..x22 and y2 in y11..y12 do
    {x1, y2, d1 + delta(y2, y11), d2 + delta(x1, x21)}
  end

  def find_intersection(_a, _b), do: nil

  def delta(a, b) do
    abs(abs(a) - abs(b))
  end
end

input = ["R8,U5,L5,D3", "U7,R6,D4,L4"]
# input = ["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"]
# input = ["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]
# input = "../inputs/day3" |> File.stream!()

[{_, _, _, w1}, {_, _, _, w2}] = Day3.parse_all(input)

intrs = Day3.intersections(w1, w2)
# |> IO.inspect(label: "intersections >>>")

# task 1
intrs
|> Enum.map(fn {x, y, _d1, _d2} -> abs(x) + abs(y) end)
|> Enum.min()
|> IO.inspect(label: "res1")

# task 2
intrs
|> Enum.map(fn {_x, _y, d1, d2} -> d1 + d2 end)
|> Enum.min()
|> IO.inspect(label: "res2")
