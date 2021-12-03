defmodule Day5 do
  @moduledoc """
  Documentation for Day5.
  """

  @doc """
  Reacts the polymer

  ## Examples

      iex> Day5.react("dabAcCaCBAcCcaDA")
      "dabCBAcaDA"
  """

  @input "dabAcCaCBAcCcaDA"
  def react(polymer \\ @input), do: react(polymer, [])

  def react(<<letter1, rest::binary>>, [letter2 | acc]) when abs(letter1 - letter2) == 32,
    do: react(rest, acc)

  def react(<<letter, rest::binary>>, acc), do: react(rest, [letter | acc])

  def react(<<>>, acc), do: acc |> Enum.reverse() |> List.to_string()

  def task1(input) do
    input |> react() |> byte_size
  end

  def task2(input) do
    full_react(input)
  end

  def get_input do
    "../inputs/day5" |> File.read!() |> String.trim()
  end

  def run do
    inp = get_input()
    res1 = task1(inp)
    {_, _, res2} = task2(inp)

    IO.puts("res1: #{res1}\nres2: #{res2}")
  end

  @doc """
  Fully reacts the polymer

  ## Examples

      iex> Day5.full_react("dabAcCaCBAcCcaDA")
      {"c", "daDA", 4}
  """
  def full_react(polymer \\ @input) do
    chars = polymer |> String.graphemes() |> Enum.map(&String.downcase/1) |> Enum.uniq()

    {char, shortest} =
      chars
      |> Enum.reduce(%{}, fn char, acc ->
        regexp = ~r/#{char}|#{String.upcase(char)}/
        clear_polymer = Regex.replace(regexp, polymer, "")

        Map.put(acc, char, react(clear_polymer))
      end)
      |> Enum.min_by(fn {_key, remain} -> byte_size(remain) end)

    {char, shortest, byte_size(shortest)}
  end

  ### ====> Jose's solution:

  def react_j(polymer), do: discard_and_react(polymer, [], nil, nil)

  @doc """
  Fully reacts the polymer by jose

  ## Examples

      iex> Day5.discard_and_react("dabAcCaCBAcCcaDA", ?A, ?a)
      "dbCBcD"
  """

  def discard_and_react(polymer, letter1, letter2) when is_binary(polymer) do
    discard_and_react(polymer, [], letter1, letter2)
  end

  def discard_and_react(<<letter, rest::binary>>, acc, dis1, dis2)
      when letter == dis1
      when letter == dis2,
      do: discard_and_react(rest, acc, dis1, dis2)

  def discard_and_react(<<letter1, rest::binary>>, [letter2 | acc], dis1, dis2)
      when abs(letter1 - letter2) == 32,
      do: discard_and_react(rest, acc, dis1, dis2)

  def discard_and_react(<<letter, rest::binary>>, acc, dis1, dis2),
    do: discard_and_react(rest, [letter | acc], dis1, dis2)

  def discard_and_react(<<>>, acc, _dis1, _dis2), do: acc |> Enum.reverse() |> List.to_string()

  @doc """
    iex> Day5.find_problematic("dabAcCaCBAcCcaDA")
    {?C, 4}
  """
  def find_problematic(polymer) do
    ?A..?Z
    |> Task.async_stream(
      fn letter ->
        {letter, discard_and_react(polymer, letter, letter + 32) |> byte_size}
      end,
      ordered: false,
      max_concurrency: 26
    )
    |> Stream.map(fn {:ok, res} -> res end)
    |> Enum.min_by(&elem(&1, 1))
  end
end
