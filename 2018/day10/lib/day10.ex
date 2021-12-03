defmodule Day10 do
  @moduledoc """
  Documentation for Day10.
  """

  @filename "../inputs/day10t"

  @doc """

  ## Examples
    iex> Day10.parse_input()
    [
      {9, 1, 0, 2},
      {7, 0, -1, 0},
      {3, -2, -1, 1},
      {6, 10, -2, -1},
      {2, -4, 2, 2},
      {-6, 10, 2, -2},
      {1, 8, 1, -1},
      {1, 7, 1, 0},
      {-3, 11, 1, -2},
      {7, 6, -1, -1},
      {-2, 3, 1, 0},
      {-4, 3, 2, 0},
      {10, -3, -1, 1},
      {5, 11, 1, -2},
      {4, 7, 0, -1},
      {8, -2, 0, 1},
      {15, 0, -2, 0},
      {1, 6, 1, 0},
      {8, 9, 0, -1},
      {3, 3, -1, 1},
      {0, 5, 0, -1},
      {-2, 2, 2, 0},
      {5, -2, 1, 2},
      {1, 4, 2, 1},
      {-2, 7, 2, -2},
      {3, 6, -1, -1},
      {5, 0, 1, 0},
      {-6, 0, 2, 0},
      {5, 9, 1, -2},
      {14, 7, -2, 0},
      {-3, 6, 2, -1}
    ]
  """
  def parse_input(filename \\ @filename) do
    File.read!(filename)
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&InputParser.point/1)
  end

  @doc """
  Solve task1:
  Day10.play(11000)
  """
  def play(num) do
    points = Day10.parse_input("../inputs/day10")

    n = get_probable_step(points, num)

    IO.puts("res1: ")
    draw_plot(points, n)
    IO.puts("res2: #{n}")
  end

  @doc """
  Solve task2:
  iex> points = Day10.parse_input("../inputs/day10")
  iex> Day10.get_probable_step(points, 15000)
  10076
  """
  def get_probable_step(points, num) do
    {n, _} =
      for n <- 0..num do
        points = prepare_points(points, n)
        [_, {min_y, max_y}] = get_min_max(points)
        {n, max_y - min_y}
      end
      |> Enum.min_by(fn {_, height} -> height end)

    n
  end

  def draw_plot(points, n \\ 0) do
    points = prepare_points(points, n)
    [{min_x, max_x}, {min_y, max_y}] = get_min_max(points)

    for y <- min_y..max_y do
      row =
        for x <- min_x..max_x do
          if Enum.any?(points, fn {px, py} ->
               px == x and py == y
             end),
             do: "#",
             else: "."
        end

      IO.puts(row)
    end
  end

  def prepare_points(points, n) do
    Enum.map(points, fn point -> move_point(point, n) end)
  end

  @doc """
  iex> Day10.move_point({3, 9, 1, -2}, 3)
  {6, 3}

  iex> Day10.move_point({7, 0, -1, 0}, 1)
  {6, 0}

  iex> Day10.move_point({3, -2, -1, 1}, 5)
  {-2, 3}
  """
  def move_point({x, y, vx, vy}, n) do
    {x + vx * n, y + vy * n}
  end

  @doc """
  iex> points = Day10.parse_input() |> Day10.prepare_points(0)
  iex> Day10.get_min_max(points)
  [{-6, 15}, {-4, 11}]
  """
  def get_min_max(points) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(points, fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(points, fn {_, y} -> y end)

    [{min_x, max_x}, {min_y, max_y}]
  end
end

defmodule InputParser do
  @regex ~r/position=<(.{1,}\d{1,}), (.{1,}\d{1,})> velocity=<(.{1,}\d{1,}), (.{1,}\d{1,})>/
  @doc """

  ## Examples

      iex> InputParser.point("position=<10, -3> velocity=<-1,  1>")
      {10, -3, -1, 1}

      iex> InputParser.point("position=< 5, 11> velocity=< 1, -2>")
      {5, 11, 1, -2}

      iex> InputParser.point("position=< 4,  7> velocity=< 0, -1>")
      {4, 7, 0, -1}

      iex> InputParser.point("position=< 8, -2> velocity=< 0,  1>")
      {8, -2, 0, 1}

      iex> InputParser.point("position=< 20316, -30055> velocity=<-2,  3>")
      {20316, -30055, -2, 3}

      iex> InputParser.point("position=<-19955,  40468> velocity=< 2, -4>")
      {-19955, 40468, 2, -4}

      iex> InputParser.point("position=<-50222,  30399> velocity=< 5, -3>")
      {-50222, 30399, 5, -3}

      iex> InputParser.point("position=< 50586,  -9911> velocity=<-5,  1>")
      {50586, -9911, -5, 1}
  """
  def point(string) when is_binary(string) do
    [[_match, x, y, vx, vy]] = Regex.scan(@regex, string)

    [x, y, vx, vy]
    |> Enum.map(fn el ->
      el |> String.trim() |> String.to_integer()
    end)
    |> List.to_tuple()
  end
end
