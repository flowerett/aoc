defmodule Day8 do
  @moduledoc """
  Documentation for Day8.
  """

  @doc """
  Parse input data.

  ## Examples
    iex> input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    iex> Day8.data(input)
    [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]

  """
  @input "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
  def data(input \\ @input) do
    input
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  @type metadata :: integer
  @type tree :: {[tree], [metadata]}

  @doc """
  Get sum for empty node

  2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
  A----------------------------------
      B----------- C-----------
                      D-----

  iex> Day8.tree_from_string()
  { #A
    [
      { #B
        [],
        [10, 11, 12]
      },
      { #C
        [
          {[], [99]} #D
        ],
        [2]
      }
    ],
    [1, 1, 2]
  }
  """
  @spec tree_from_string(String.t()) :: tree()
  def tree_from_string(input \\ @input) do
    {root, []} =
      input
      |> data()
      |> build_node()

    root
  end

  defp build_node([num_children, num_metadata | rest]) do
    {children, rest} = children(num_children, rest, [])

    {metadata, rest} = Enum.split(rest, num_metadata)
    {{children, metadata}, rest}
  end

  defp children(0, rest, acc) do
    {Enum.reverse(acc), rest}
  end

  defp children(count, rest, acc) do
    {node, rest} = build_node(rest)
    children(count - 1, rest, [node | acc])
  end

  @doc """
  Get sum meta from tree

  iex> tree = Day8.tree_from_string()
  iex> Day8.sum_metadata(tree)
  138
  """
  @spec sum_metadata(tree) :: integer()
  def sum_metadata(tree) do
    sum_metadata(tree, 0)
  end

  defp sum_metadata({children, metadata}, acc) do
    sum_children = Enum.reduce(children, 0, &sum_metadata/2)

    sum_children + Enum.sum(metadata) + acc
  end

  @doc """
  iex> tree = Day8.tree_from_string()
  iex> Day8.indexed_sum(tree)
  66
  """
  @spec indexed_sum(tree) :: integer()
  def indexed_sum({[], metadata}) do
    Enum.sum(metadata)
  end

  def indexed_sum({children, metadata}) do
    indexed_sums = Enum.map(children, &indexed_sum/1)

    Enum.reduce(metadata, 0, fn index, acc ->
      Enum.at(indexed_sums, index - 1, 0) + acc
    end)
  end
end
