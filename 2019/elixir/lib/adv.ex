defmodule Adv do
  @moduledoc false

  @doc """
    iex> Adv.hello()
    :advent
  """
  def hello do
    :advent
  end

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @input Keyword.get(opts, :input)
      @transform Keyword.get(opts, :transform, &Adv.__dummy_transform__/1)
      @post Keyword.get(opts, :post, &Adv.__dummy_post__/1)

      def input() do
        @input
        |> File.stream!()
        |> Enum.map(&__prepare_row__/1)
        |> __post__()
      end

      def __prepare_row__(row) do
        row
        |> String.trim()
        |> __transform__()
      end

      def __transform__(row), do: @transform.(row)
      def __post__(list), do: @post.(list)
    end
  end

  def __dummy_transform__(row), do: row
  def __dummy_post__(list), do: list
end
