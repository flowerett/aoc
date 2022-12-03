# parse the input
calories =
  File.stream!("../inputs/day1")
  |> Stream.map(&String.trim/1)
  |> Stream.chunk_by(&(&1 == ""))
  |> Stream.reject(&(&1 == [""]))
  |> Enum.map(fn chunk ->
    chunk
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end)

# find the elf with the most calories
most_calories = Enum.max(calories)

# print the result
IO.puts("The elf carrying the most calories has a total of #{most_calories} calories.")

# find the top three elves with the most calories
top_three_calories =
  Enum.sort(calories, &(&1 >= &2))
  |> Enum.take(3)

# calculate the total number of calories for the top three elves
total_calories = Enum.reduce(top_three_calories, 0, &(&1 + &2))

# print the result
IO.puts("The top three elves are carrying a total of #{total_calories} calories.")
