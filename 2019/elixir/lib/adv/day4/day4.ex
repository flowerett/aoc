defmodule Adv.Day4 do
  @input 372_304..847_060

  @doc ~S"""
    iex> solve1()
    475
  """
  def solve1 do
    @input
    |> Enum.filter(&is_pass/1)
    |> length
  end

  @doc ~S"""
    iex> solve2()
    297
  """
  def solve2 do
    @input
    |> Enum.filter(&is_pass2/1)
    |> length
  end

  @doc ~S"""
    iex> is_pass(111111)
    true

    iex> is_pass(223450)
    false

    iex> is_pass(123789)
    false
  """
  def is_pass(number) do
    %{i: inc, d: dd, l: _} =
      number
      |> Integer.digits()
      |> Enum.reduce(%{i: true, d: false, l: nil}, fn x, %{i: i, d: d, l: l} ->
        inc = i && (is_nil(l) || x >= l)
        dd = d || l == x

        %{i: inc, d: dd, l: x}
      end)

    inc && dd
  end

  @doc ~S"""
    iex> is_pass2(112233)
    true

    iex> is_pass2(123444)
    false

    iex> is_pass2(111122)
    true
  """
  def is_pass2(number) do
    arr = Integer.digits(number)

    inc = Enum.sort(arr) == arr

    dd =
      arr
      |> Enum.group_by(& &1)
      |> Enum.any?(fn {_k, v} ->
        length(v) == 2
      end)

    inc && dd
  end
end
