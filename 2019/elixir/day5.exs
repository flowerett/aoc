defmodule Day5 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def get_modes(instr) do
    cmd = rem(instr, 100)

    modes =
      instr
      |> div(100)
      |> Integer.to_string()
      |> String.pad_leading(3, "0")
      |> String.split("")
      |> Enum.reject(&(&1 == ""))
      |> Enum.reverse()

    {cmd, modes}
  end

  def get_args(args, modes, acc) do
    larg = length(args)
    norm_modes = Enum.take(modes, larg)

    norm_modes
    |> Enum.zip(args)
    |> Enum.map(&get_arg(&1, acc))
  end

  def get_arg({"0", x}, acc), do: Enum.at(acc, x)
  def get_arg({"1", x}, _acc), do: x

  def run(acc, idx, inp) do
    {processed, rest} = Enum.split(acc, idx + 1)

    instr = List.last(processed)
    {cmd, modes} = get_modes(instr)
    # IO.puts("idx: #{idx}, cmd: #{cmd}, md: #{modes}")

    op(cmd, modes, acc, rest, idx, inp)
  end

  def op(1, modes, acc, [x, y, adr | _], idx, inp) do
    [xx, yy] = get_args([x, y], modes, acc)

    acc
    |> List.replace_at(adr, xx + yy)
    # |> IO.inspect(label: "op1 >>>")
    |> run(idx + 4, inp)
  end

  def op(2, modes, acc, [x, y, adr | _], idx, inp) do
    [xx, yy] = get_args([x, y], modes, acc)

    acc
    |> List.replace_at(adr, xx * yy)
    # |> IO.inspect(label: "op2 >>>")
    |> run(idx + 4, inp)
  end

  def op(3, _modes, acc, [adr | _], idx, inp) do
    acc
    |> List.replace_at(adr, inp)
    # |> IO.inspect(label: "op3 >>>")
    |> run(idx + 2, inp)
  end

  def op(4, _modes, acc, [adr | _], idx, inp) do
    Enum.at(acc, adr) |> IO.inspect(label: "OUT")

    acc
    # |> IO.inspect(label: "op4 >>>")
    |> run(idx + 2, inp)
  end

  def op(99, _modes, acc, _cmd, _idx, _inp) do
    IO.puts("halt")
    acc
  end

  def op(opcode, _modes, _acc, _cmd, _idx, _inp), do: raise("unknown code #{opcode}, halt!")
end

# test with d2 input
# input = """
# 1,9,10,3,2,3,11,0,99,30,40,50
# """

# test opcodes 3, 4
# input = """
# 3,0,4,0,99
# """

# test modes (0,1)
# input = """
# 1002,4,3,4,33
# """

# data = Day5.parse_input(input)
data = "../inputs/day5" |> File.read!() |> Day5.parse_input()

data
|> IO.inspect(label: "start >>>")
|> Day5.run(0, 1)
|> List.first()
|> IO.inspect(label: "res")
