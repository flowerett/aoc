
#! /usr/bin/env elixir

hex = ~w(0 1 2 3 4 5 6 7 8 9 A B C D E F)

hex
|> Enum.map(fn c ->
  c |> String.to_integer(16) |> Integer.to_string(2) |> String.pad_leading(4, "0")
end)
|> IO.inspect()
