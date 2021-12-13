#! /usr/bin/env elixir

defmodule Day13 do
  def parse(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_row/1)
    |> Enum.reject(&is_nil/1)
  end

  def parse_row(""), do: nil

  def parse_row(<<"fold along ", cmd::binary>>) do
    [f, n] = String.split(cmd, "=")
    {:cmd, String.to_atom(f), String.to_integer(n)}
  end

  def parse_row(row) do
    [x, y] = row |> String.split(",") |> Enum.map(&String.to_integer/1)
    {:dot, {x, y}}
  end

  def fold({:dot, key}, dots) do
    Map.put(dots, key, :"#")
  end

  def fold({:cmd, :y, n}, dots) do
    out = Map.get(dots, :out, false)

    dots
    |> Map.delete(:out)
    |> Map.keys()
    |> Enum.map(fn {x, y} ->
      (y < n && {x, y}) || {x, 2 * n - y}
    end)
    |> Enum.map(&{&1, :"#"})
    |> Enum.into(%{})
    |> maybe_print_res1(out)
  end

  def fold({:cmd, :x, n}, dots) do
    out = Map.get(dots, :out, false)

    dots
    |> Map.delete(:out)
    |> Map.keys()
    |> Enum.map(fn {x, y} ->
      (x < n && {x, y}) || {2 * n - x, y}
    end)
    |> Enum.map(&{&1, :"#"})
    |> Enum.into(%{})
    |> maybe_print_res1(out)
  end

  def fold(r, _dots) do
    raise "unknown row to fold: #{r.inspect}"
  end

  def maybe_print_res1(dots, true) do
    dots |> Enum.count() |> IO.inspect(label: "res1")
    dots
  end

  def maybe_print_res1(dots, false), do: dots

  def get_size(dots) do
    keys = Map.keys(dots)
    {x, _} = Enum.max_by(keys, fn {x, _y} -> x end)
    {_, y} = Enum.max_by(keys, fn {_x, y} -> y end)

    {x, y}
  end
end

# input =
# """
# 6,10
# 0,14
# 9,10
# 0,3
# 10,4
# 4,11
# 6,0
# 6,12
# 4,1
# 0,13
# 10,12
# 3,4
# 3,0
# 8,4
# 1,10
# 2,14
# 8,10
# 9,0

# fold along y=7
# fold along x=5
# """
# |> String.split("\n")

input = "../inputs/day13" |> File.stream!()

msg =
  input
  |> Day13.parse()
  |> Enum.reduce(%{out: true}, &Day13.fold/2)

{x, y} = Day13.get_size(msg)

IO.puts("res2: ")

# EFJKZLBL
Enum.each(0..y, fn y ->
  Enum.map(0..x, fn x ->
    Map.get(msg, {x, y}, " ")
  end)
  |> Enum.join()
  |> IO.puts()
end)
