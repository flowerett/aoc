defmodule Codetricks do
end

defmodule Matrix do
  # def transform(list) do
  # end

  @doc """
  iex> Matrix.size([])
  {0,0}

  iex> Matrix.size([1])
  {1,1}

  iex> matrix = Matrix.build_from_list([1,2,3,4])
  iex> Matrix.size(matrix)
  {2, 2}

  iex> matrix = Matrix.build_from_list([1,2,3,4,5,6,7,8,9,10])
  iex> Matrix.size(matrix)
  {4, 3}
  """
  def size(matrix) do
    rows = length(matrix)

    cols =
      case List.first(matrix) do
        col when is_list(col) -> col |> length
        nil -> 0
        _ -> 1
      end

    {rows, cols}
  end

  @doc """
  iex> Matrix.build_from_list([])
  []

  iex> Matrix.build_from_list([1])
  [1]

  iex> Matrix.build_from_list([1, 2])
  [1, 2]

  iex> Matrix.build_from_list([1,2,3,4])
  [[1,2],[3,4]]

  iex> Matrix.build_from_list([1,2,3,4,5,6,7,8,9,10])
  [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]]

  """
  def build_from_list(list) when is_list(list) do
    len = length(list)
    row_len = :math.sqrt(len) |> trunc

    case row_len do
      x when x <= 1 -> list
      _ -> list |> Enum.chunk_every(row_len)
    end
  end
end
