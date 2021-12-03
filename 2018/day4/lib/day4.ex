defmodule FrequencyMap do
  @moduledoc """
  Fancy staff with collectable protocol
  """

  defstruct data: %{}

  def new do
    %FrequencyMap{}
  end

  def most_frequent(%FrequencyMap{data: data}) when data == %{}, do: :error

  def most_frequent(%FrequencyMap{data: data}) do
    Enum.max_by(data, fn {_, count} -> count end)
  end

  defimpl Collectable do
    def into(%FrequencyMap{data: data}) do
      collector_fun = fn
        data, {:cont, elem} -> Map.update(data, elem, 1, &(&1 + 1))
        data, :done -> %FrequencyMap{data: data}
        _, :halt -> :ok
      end

      {data, collector_fun}
    end
  end
end

defmodule Day4 do
  @moduledoc false

  import NimbleParsec

  guard_command =
    ignore(string("Guard #"))
    |> unwrap_and_tag(integer(min: 1), :shift)
    |> ignore(string(" begins shift"))

  asleep_command = string("falls asleep") |> replace(:down)
  wakeup_command = string("wakes up") |> replace(:up)

  defparsecp(
    :parsec_log,
    ignore(string("["))
    |> integer(4)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string(" "))
    |> integer(2)
    |> ignore(string(":"))
    |> integer(2)
    |> ignore(string("] "))
    |> choice([guard_command, asleep_command, wakeup_command])
  )

  @doc """
  Parses the log.

  ## Examples

      iex> Day4.parse_log("[1518-08-17 00:01] Guard #3529 begins shift")
      {{1518, 08, 17}, 00, 01, {:shift, 3529}}

      iex> Day4.parse_log("[1518-07-07 00:21] falls asleep")
      {{1518, 7, 7}, 0, 21, :down}

      iex> Day4.parse_log("[1518-07-13 00:59] wakes up")
      {{1518, 7, 13}, 0, 59, :up}
  """

  def parse_log(string) when is_binary(string) do
    {:ok, [year, month, day, hour, minute, command], "", _, _, _} = parsec_log(string)
    {{year, month, day}, hour, minute, command}
  end

  @doc """
  Groups the input.

  ## Examples

  iex> Day4.group_by_id_and_date([
  ...>   "[1518-11-01 00:25] wakes up",
  ...>   "[1518-11-04 00:02] Guard #99 begins shift",
  ...>   "[1518-11-02 00:40] falls asleep",
  ...>   "[1518-11-03 00:24] falls asleep",
  ...>   "[1518-11-03 00:05] Guard #10 begins shift",
  ...>   "[1518-11-01 00:55] wakes up",
  ...>   "[1518-11-03 00:29] wakes up",
  ...>   "[1518-11-02 00:50] wakes up",
  ...>   "[1518-11-05 00:03] Guard #99 begins shift",
  ...>   "[1518-11-04 00:46] wakes up",
  ...>   "[1518-11-05 00:45] falls asleep",
  ...>   "[1518-11-01 00:00] Guard #10 begins shift",
  ...>   "[1518-11-01 00:05] falls asleep",
  ...>   "[1518-11-04 00:36] falls asleep",
  ...>   "[1518-11-01 00:30] falls asleep",
  ...>   "[1518-11-05 00:55] wakes up",
  ...>   "[1518-11-01 23:58] Guard #99 begins shift"
  ...> ])
  [
    {10, {1518, 11, 1}, [5..24, 30..54]},
    {99, {1518, 11, 2}, [40..49]},
    {10, {1518, 11, 3}, [24..28]},
    {99, {1518, 11, 4}, [36..45]},
    {99, {1518, 11, 5}, [45..54]}
  ]
  """

  def group_by_id_and_date(unsorted_logs) do
    unsorted_logs
    |> Enum.map(&parse_log/1)
    |> Enum.sort()
    |> group_by_id_and_date([])
  end

  defp group_by_id_and_date([{date, hour, minute, {:shift, id}} | rest], groups) do
    {rest, ranges} = get_asleep_ranges(rest, [])
    date = handle_date_shift(date, hour, minute)
    group_by_id_and_date(rest, [{id, date, ranges} | groups])
  end

  defp group_by_id_and_date([], data), do: Enum.reverse(data)

  defp get_asleep_ranges([{_, _, down_min, :down}, {_, _, up_min, :up} | rest], acc) do
    get_asleep_ranges(rest, [down_min..(up_min - 1) | acc])
  end

  defp get_asleep_ranges(rest, ranges), do: {rest, Enum.reverse(ranges)}

  defp handle_date_shift(date, 0, _min), do: date
  defp handle_date_shift({year, month, day}, _hour, _min), do: {year, month, day + 1}

  @doc """
  Sums asleep times by guard id

  iex> Day4.sum_asleep_times_by_id([
  ...>   {10, {1518, 11, 1}, [5..24, 30..54]},
  ...>   {99, {1518, 11, 2}, [40..49]},
  ...>   {10, {1518, 11, 3}, [24..28]},
  ...>   {99, {1518, 11, 4}, [36..45]},
  ...>   {99, {1518, 11, 5}, [45..54]}
  ...> ])
  %{
    10 => 50,
    99 => 30
  }
  """
  def sum_asleep_times_by_id(groups) do
    Enum.reduce(groups, %{}, fn {id, _date, ranges}, acc ->
      sum = ranges |> Enum.map(&Enum.count/1) |> Enum.sum()
      Map.update(acc, id, sum, &(sum + &1))
    end)
  end

  @doc """
    iex> Day4.id_asleep_the_most(%{10 => 50, 99 => 30, 1 => 3})
    10
  """
  def id_asleep_the_most(map) do
    {id, _} = Enum.max_by(map, fn {_id, sum_asleep} -> sum_asleep end)
    id
  end

  @doc """
    iex> Day4.minute_asleep_the_most_by_id([
    ...>   {10, {1518, 11, 1}, [5..24, 30..54]},
    ...>   {99, {1518, 11, 2}, [40..49]},
    ...>   {10, {1518, 11, 3}, [24..28]},
    ...>   {99, {1518, 11, 4}, [36..45]},
    ...>   {99, {1518, 11, 5}, [45..54]}
    ...> ], 10)
    24
  """
  def minute_asleep_the_most_by_id(groups, id) do
    all_minutes =
      for {^id, _date, ranges} <- groups,
          range <- ranges,
          minute <- range,
          do: minute

    {minute, _} =
      all_minutes
      |> Enum.group_by(& &1)
      |> Enum.max_by(fn {_id, count} -> length(count) end)

    minute
  end

  @doc """
    iex> Day4.fancy_most_freq_minute([
    ...>   {10, {1518, 11, 1}, [5..24, 30..54]},
    ...>   {99, {1518, 11, 2}, [40..49]},
    ...>   {10, {1518, 11, 3}, [24..28]},
    ...>   {99, {1518, 11, 4}, [36..45]},
    ...>   {99, {1518, 11, 5}, [45..54]},
    ...>   {97, {1518, 11, 5}, []}
    ...> ], 99)
    {45, 3}

    iex> Day4.fancy_most_freq_minute([
    ...>   {97, {1518, 11, 5}, []}
    ...> ], 97)
    :error
  """
  def fancy_most_freq_minute(groups, id) do
    freq_map =
      for {^id, _date, ranges} <- groups,
          range <- ranges,
          minute <- range,
          do: minute,
          into: FrequencyMap.new()

    FrequencyMap.most_frequent(freq_map)
  end

  def get_input do
    "../inputs/day4"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def run do
    inp = get_input()
    inp |> task1() |> IO.inspect(label: "res1")
    inp |> task2() |> IO.inspect(label: "res2")
    :ok
  end

  def task1(input) do
    groups = group_by_id_and_date(input)

    id = groups |> sum_asleep_times_by_id |> id_asleep_the_most
    minute = minute_asleep_the_most_by_id(groups, id)

    id * minute
  end

  def task2(input) do
    groups = group_by_id_and_date(input)

    {id, {min, _occ}} =
      groups
      |> group_by_id_min_occur
      |> Enum.max_by(fn {_id, {_min, occur}} -> occur end)

    id * min
  end

  defp group_by_id_min_occur(groups) do
    Enum.reduce(groups, %{}, fn {id, _, _}, acc ->
      case acc do
        %{^id => _} ->
          acc

        %{} ->
          case fancy_most_freq_minute(groups, id) do
            :error -> acc
            tuple -> Map.put(acc, id, tuple)
          end
      end
    end)
  end
end
