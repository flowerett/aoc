defmodule Day3 do
  def parse_input(input) do
    input
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_row/1)
  end

  def parse_row(row) do
    row
    |> String.split(" -> ")
    |> Enum.flat_map(&String.split(&1, ","))
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def overlaps(lines, task \\ :t1) do
    lines
    |> Enum.map(&to_dot(&1, task))
    |> Enum.reject(&is_nil/1)
    |> List.flatten()
    |> Enum.group_by(fn el -> el end)
    |> Enum.reject(fn {_k, v} -> length(v) == 1 end)
    |> Enum.map(fn {k, _v} -> k end)
    |> Enum.uniq()
  end

  # horizontal
  # {0, 9, 5, 9}
  def to_dot({x1, y, x2, y}, _) do
    for x <- x1..x2 do
      {x, y}
    end
  end

  # vertical
  # {7, 0, 7, 4}
  def to_dot({x, y1, x, y2}, _) do
    for y <- y1..y2 do
      {x, y}
    end
  end

  # diagonal
  # {1, 1, 3, 3}
  # {8, 0, 0, 8}
  # {6, 4, 2, 0}
  # T1 - remove this clause
  def to_dot({x1, y1, x2, y2}, :t2) do
    {deltax, deltay} = {x2 - x1, y2 - y1}
    da = abs(deltax)

    if da == abs(deltay) do
      {dsx, dsy} = {dsig(x1, x2), dsig(y1, y2)}

      for d <- 0..da do
        {x1 + d * dsx, y1 + d * dsy}
      end
    end
  end

  def to_dot(_, _), do: nil

  def dsig(d1, d2) do
    if d1 > d2, do: -1, else: 1
  end
end

# input = "../inputs/day5t" |> File.stream!()
input = "../inputs/day5" |> File.stream!()

# T1/2
input
|> Day3.parse_input()
|> Day3.overlaps(:t1)
# |> IO.inspect(label: "overlaps")
|> length()
|> IO.inspect(label: "res1")

# T2
input
|> Day3.parse_input()
|> Day3.overlaps(:t2)
# |> IO.inspect(label: "overlaps")
|> length()
|> IO.inspect(label: "res2")
