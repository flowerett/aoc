defmodule Adv.Day3 do
  @input "../inputs/day3"

  # alias __MODULE__

  use Adv,
    input: @input

  @test_input ["R8,U5,L5,D3", "U7,R6,D4,L4"]

  @doc ~S"""
  These wires cross at two locations (marked X),
  but the lower-left one is closer to the central port.
  ...........
  .+-----+...
  .|.....|...
  .|..+--X-+.
  .|..|..|.|.
  .|.-X--+.|.
  .|..|....|.
  .|.......|.
  .o-------+.

  its manhattan distance is 3 + 3 = 6.

  iex> examples()
  [6, 159, 135]
  """
  def examples do
    [
      @test_input,
      ["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"],
      ["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]
    ]
    |> Enum.map(&solve1/1)
  end

  @doc ~S"""
  1. convert vectors to 2-coord points
  2. compare each verctor from set1 & set2, => compute crossing point
  3. find closest crossing point

  iex> solve1()
  6

  iex> input() |> solve1()
  1064
  """
  def solve1(input \\ @test_input) do
    {x, y} =
      input
      |> convert_vectors()
      |> intersections()
      |> Enum.min_by(fn {x, y} ->
        abs(x) + abs(y)
      end)

    abs(x) + abs(y)
  end

  @doc ~S"""
  iex> convert_vectors()
  [
    [
      %{x: {0, 8}, y: 0},
      %{x: 8, y: {0, 5}},
      %{x: {3, 8}, y: 5},
      %{x: 3, y: {2, 5}}
    ],
    [
      %{x: 0, y: {0, 7}},
      %{x: {0, 6}, y: 7},
      %{x: 6, y: {3, 7}},
      %{x: {2, 6}, y: 3}
    ]
  ]
  """
  def convert_vectors(input \\ @test_input) do
    input
    |> Enum.map(fn row ->
      row
      |> String.split(",")
      |> Enum.reduce({{0, 0}, []}, &vector_reducer/2)
      |> elem(1)
      |> Enum.reverse()
    end)
  end

  defp vector_reducer(<<dir, magnitude::binary>>, {{x, y}, acc}) do
    len = String.to_integer(magnitude)
    {point, el} = v2point(dir, len, x, y)
    {point, [el | acc]}
  end

  # {x, y, x + l, y}
  defp v2point(?R, l, x, y), do: {{x + l, y}, %{x: {x, x + l}, y: y}}
  # {x, y, x - l, y}
  defp v2point(?L, l, x, y), do: {{x - l, y}, %{x: {x - l, x}, y: y}}
  # {x, y, x, y + l}
  defp v2point(?U, l, x, y), do: {{x, y + l}, %{x: x, y: {y, y + l}}}
  # {x, y, x, y - l}
  defp v2point(?D, l, x, y), do: {{x, y - l}, %{x: x, y: {y - l, y}}}

  @doc ~S"""
  iex> convert_vectors() |> intersections()
  [{6, 5}, {3, 3}]
  """
  def intersections([row1, row2]) do
    for v1 <- row1, v2 <- row2 do
      compare_vectors(v1, v2)
    end
    |> Enum.reject(&is_nil/1)
    |> Enum.reject(&(&1 == {0, 0}))
  end

  defp compare_vectors(%{x: {x11, x12}, y: y1}, %{x: x2, y: {y21, y22}})
       when x11 <= x2 and x2 <= x12 and y21 <= y1 and y1 <= y22,
       do: {x2, y1}

  defp compare_vectors(%{x: x1, y: {y11, y12}}, %{x: {x21, x22}, y: y2})
       when x21 <= x1 and x1 <= x22 and y11 <= y2 and y2 <= y12,
       do: {x1, y2}

  defp compare_vectors(_, _), do: nil
end
