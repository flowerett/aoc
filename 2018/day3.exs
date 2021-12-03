Code.require_file("matrix.exs")

defmodule Day3 do
  @test_input [
    "#1 @ 1,3: 4x4",
    "#2 @ 3,1: 4x4",
    "#3 @ 5,5: 2x2"
  ]
  # @row_regex ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
  @alt_regex ~r/\d+/

  def get_input do
    "inputs/day3"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  # https://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir/
  def init_fabric(x \\ 10, y \\ 10) do
    Matrix.init([], x) |> Matrix.init(y)
  end

  # list_fabric:
  # grid = Enum.map(1..5, fn i -> Enum.map(1..5, fn j -> ["#{i}.#{j}"] end) end)
  # grid |> Enum.at(0) |> Enum.at(1)

  # read
  # grid[9][1]

  # write
  # grid = put_in grid[9][1], grid[9][1] ++ ["9'.1'"]

  def process_input(input \\ @test_input) do
    input
    |> Enum.map(fn row ->
      Regex.scan(@alt_regex, row)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def fill_area(input, x, y) do
    fabric = init_fabric(x, y)

    input
    |> Enum.reduce(fabric, fn [id, y, x, h, w], i_acc ->
      x..(x + w - 1)
      |> Enum.reduce(i_acc, fn row, row_acc ->
        y..(y + h - 1)
        |> Enum.reduce(row_acc, fn cell, cell_acc ->
          put_in(cell_acc[row][cell], cell_acc[row][cell] ++ [id])
        end)
      end)
    end)
  end

  def claimed_inches(claims) do
    Enum.reduce(claims, %{}, fn [id, y, x, h, w], acc ->
      Enum.reduce((x + 1)..(x + w), acc, fn x, acc ->
        Enum.reduce((y + 1)..(y + h), acc, fn y, acc ->
          Map.update(acc, {x, y}, [id], &[id | &1])
        end)
      end)
    end)
  end

  def claimed_ets(claims) do
    table = :ets.new(:claimed_inches, [:duplicate_bag, :private])

    for [id, y, x, h, w] <- claims,
        x <- (x + 1)..(x + w),
        y <- (y + 1)..(y + h) do
      :ets.insert(table, {{x, y}, id})
    end

    table
  end

  def count_area(matrix) do
    matrix
    |> Matrix.to_list()
    |> Enum.map(fn row ->
      row
      |> Enum.reduce(0, fn cell, acc ->
        if length(cell) > 1, do: acc + 1, else: acc
      end)
    end)
    |> Enum.sum()
  end

  def get_clear_area(input, matrix) do
    [[id | _rest]] =
      input
      |> Enum.filter(fn [_id, y, x, h, w] ->
        x..(x + w - 1)
        |> Enum.all?(fn row ->
          y..(y + h - 1)
          |> Enum.all?(fn cell ->
            length(matrix[row][cell]) == 1
          end)
        end)
      end)

    id
  end

  # 112418
  def task1() do
    get_input()
    |> process_input()
    |> fill_area(999, 999)
    |> count_area()
  end

  # 560
  def task2() do
    data = get_input() |> process_input()
    matrix = data |> fill_area(999, 999)

    get_clear_area(data, matrix)
  end
end

Day3.task1() |> IO.inspect(label: "res1")
Day3.task2() |> IO.inspect(label: "res2")
