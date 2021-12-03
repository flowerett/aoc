defmodule Day4 do
  @example """
  [1518-11-01 00:00] Guard #10 begins shift
  [1518-11-01 00:05] falls asleep
  [1518-11-01 00:25] wakes up
  [1518-11-01 00:30] falls asleep
  [1518-11-01 00:55] wakes up
  [1518-11-01 23:58] Guard #99 begins shift
  [1518-11-02 00:40] falls asleep
  [1518-11-02 00:50] wakes up
  [1518-11-03 00:05] Guard #10 begins shift
  [1518-11-03 00:24] falls asleep
  [1518-11-03 00:29] wakes up
  [1518-11-04 00:02] Guard #99 begins shift
  [1518-11-04 00:36] falls asleep
  [1518-11-04 00:46] wakes up
  [1518-11-05 00:03] Guard #99 begins shift
  [1518-11-05 00:45] falls asleep
  [1518-11-05 00:55] wakes up
  """

  @data_regex ~r/\d+|wakes up|falls asleep/

  def get_input() do
    "../inputs/day4"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> format_input()
  end

  def format_input(input \\ @example) do
    input
    |> Enum.sort()
    |> Enum.map(&Regex.scan(@data_regex, &1))
    |> Enum.map(&List.flatten/1)
  end

  @doc """
  Parses the log with regexp.

  ## Examples

      iex> Day4.parse_reg("[1518-08-17 00:01] Guard #3529 begins shift")
      {{1518, 08, 17}, 00, 01, {:shift, 3529}}

      iex> Day4.parse_reg("[1518-07-07 00:21] falls asleep")
      {{1518, 7, 7}, 0, 21, :down}

      iex> Day4.parse_reg("[1518-07-13 00:59] wakes up")
      {{1518, 7, 13}, 0, 59, :up}
  """
  @data_regex ~r/\d+|wakes up|falls asleep/

  def parse_reg(string) when is_binary(string) do
    [year, month, day, hour, minute, command] = Regex.scan(@data_regex, string) |> List.flatten()

    [year, month, day, hour, minute] =
      [year, month, day, hour, minute] |> Enum.map(&String.to_integer/1)

    case command do
      "falls asleep" -> {{year, month, day}, hour, minute, :down}
      "wakes up" -> {{year, month, day}, hour, minute, :up}
      id -> {{year, month, day}, hour, minute, {:shift, String.to_integer(id)}}
    end
  end
end
