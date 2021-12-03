# data = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

data =
  "../inputs/day1"
  |> File.read!()
  |> String.split()
  |> Enum.map(&(&1 |> String.trim() |> String.to_integer()))

# t1
data
|> Enum.reduce({0, nil}, fn val, {count, prev} ->
  case prev do
    prev when not is_nil(prev) and prev < val ->
      {count + 1, val}

    _prev ->
      {count, val}
  end
end)
|> elem(0)
|> IO.inspect(label: "res1")

# t2
data
|> Enum.reduce({0, [nil, nil, nil]}, fn val, {count, win} ->
  [_a, b, c] = win
  new_win = [b, c, val]

  if Enum.any?(win, &is_nil(&1)) or Enum.any?(new_win, &is_nil(&1)) do
    {count, new_win}
  else
    sum = Enum.sum(win)
    new_sum = Enum.sum(new_win)

    if sum < new_sum, do: {count + 1, new_win}, else: {count, new_win}
  end
end)
|> elem(0)
|> IO.inspect(label: "res2")
