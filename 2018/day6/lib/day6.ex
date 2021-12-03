defmodule Day6 do
  @moduledoc """
  Documentation for Day6.
  """

  @doc """
  Parse coordinate.

  iex> Day6.parse_coordinate("8, 9")
  {8, 9}
  """
  def parse_coordinate(row) when is_binary(row) do
    [x, y] = row |> String.split(", ")
    {String.to_integer(x), String.to_integer(y)}
  end

  @doc """
  Create a bounding box for the coordinates.

  iex> Day6.bounding_box([
  ...>  {1, 1},
  ...>  {1, 6},
  ...>  {8, 3},
  ...>  {3, 4},
  ...>  {5, 5},
  ...>  {8, 9}
  ...>])
  {1..8, 1..9}
  """
  def bounding_box(coordinates) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coordinates, &elem(&1, 0))
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coordinates, &elem(&1, 1))

    {min_x..max_x, min_y..max_y}
  end

  @doc """
  Build grid with closest points.

  iex> Day6.closest_grid([{1,1}, {3,3}], 1..3, 1..3)
  %{
    {1, 1} => {1, 1},
    {1, 2} => {1, 1},
    {1, 3} => nil,
    {2, 1} => {1, 1},
    {2, 2} => nil,
    {2, 3} => {3, 3},
    {3, 1} => nil,
    {3, 2} => {3, 3},
    {3, 3} => {3, 3}
  }

  # representation for:
  # 1 1 .
  # 1 . 3
  # . 3 3
  """
  def closest_grid(coordinates, x_range, y_range) do
    for x <- x_range,
        y <- y_range,
        point = {x, y},
        do: {point, classify_coordinate(coordinates, point)},
        into: %{}
  end

  defp classify_coordinate(coordinates, point) do
    coordinates
    |> Enum.map(&{manhattan_distance(&1, point), &1})
    |> Enum.sort()
    |> case do
      # self
      [{0, coord} | _] -> coord
      # equal
      [{distance, _}, {distance, _} | _] -> nil
      # closest
      [{_, coord} | _] -> coord
    end
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  @doc """
  Get infinite coords from the grid.

  iex> grid = Day6.closest_grid([{1,1}, {3,3}, {5,5}], 1..5, 1..5)
  iex> set = Day6.infinite_coords(grid, 1..5, 1..5)
  iex> Enum.sort(set)
  [{1, 1}, {5,5}]
  """
  def infinite_coords(grid, x_range, y_range) do
    infinite_for_x =
      for y <- [y_range.first, y_range.last],
          x <- x_range,
          closest = grid[{x, y}],
          do: closest

    infinite_for_y =
      for x <- [x_range.first, x_range.last],
          y <- y_range,
          closest = grid[{x, y}],
          do: closest

    MapSet.new(infinite_for_x ++ infinite_for_y)
  end

  @doc """
  Get all finite coords with corresponding areas.

  iex> Day6.finite_areas([{1,1}, {3,3}, {5,5}])
  %{{3,3} => 7}
  """
  def finite_areas(coordinates) do
    {x_range, y_range} = bounding_box(coordinates)
    closest_grid = closest_grid(coordinates, x_range, y_range)

    infinite_coords = infinite_coords(closest_grid, x_range, y_range)

    Enum.reduce(closest_grid, %{}, fn {_point, coord}, acc ->
      if coord == nil or coord in infinite_coords do
        acc
      else
        Map.update(acc, coord, 1, &(&1 + 1))
      end
    end)
  end

  @doc """
  Get finite coord with MAX area

  iex> Day6.max_finite_area([{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}])
  {{5, 5}, 17}
  """
  def max_finite_area(coordinates) do
    coordinates
    |> finite_areas()
    |> Enum.max_by(fn {_coord, count} -> count end)
  end

  @doc """
  Solve task1

  iex> Day6.task1()
  {{166, 169}, 5532}
  """
  def task1 do
    "../inputs/day6"
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_coordinate/1)
    |> max_finite_area()
  end

  ###########

  @doc """
  Build grid with total distance to point
  less than passed value and returns total area.

  iex> Day6.sum_grid([
  ...>  {1, 1},
  ...>  {1, 6},
  ...>  {8, 3},
  ...>  {3, 4},
  ...>  {5, 5},
  ...>  {8, 9}
  ...> ], 1..8, 1..9, 32)
  16

  # representation for:
  A . . . . . . .
  . . . . . . . .
  . . # # # . . C
  . # D # # # . .
  . # # # E # . .
  B . # # # . . .
  . . . . . . . .
  . . . . . . . .
  . . . . . . . F
  """
  def sum_grid(coordinates, x_range, y_range, max_distance) do
    Task.async_stream(
      x_range,
      fn x ->
        Enum.reduce(y_range, 0, fn y, count ->
          point = {x, y}
          if sum_distance(coordinates, point) < max_distance, do: count + 1, else: count
        end)
      end,
      ordered: false
    )
    |> Enum.reduce(0, fn {:ok, count}, acc -> count + acc end)
  end

  def sum_distance(coordinates, point) do
    coordinates
    |> Enum.map(&manhattan_distance(&1, point))
    |> Enum.sum()
  end

  @doc """
  The size of the region containing all locations
  which have a total distance to all given coordinates
  of less than 10000.

  iex> Day6.task2(10000)
  36216
  """
  def task2(max_distance \\ 10_000) do
    coordinates =
      "../inputs/day6"
      |> File.read!()
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_coordinate/1)

    {x_range, y_range} = bounding_box(coordinates)

    coordinates
    |> sum_grid(x_range, y_range, max_distance)
  end

  def run do
    {_, res1} = task1()
    res2 = task2(10_000)

    IO.puts("res1: #{res1}\nres2: #{res2}")
  end
end
