defmodule Word do

  @moduledoc """
  Provides functions to manipulate words
  """

  @doc """

  Converts the word to the list of tokens
  of size n by sequential splitting on each
  char

  Example:

  iex> Word.seq_split "word", 2
  ["wo", "or", "rd"]

  iex> Word.seq_split "тест", 3
  ["тес", "ест"]

  iex> Word.seq_split "ox", 2
  ["ox"]

  iex> Word.seq_split "x", 2
  []

  """

  def seq_split(string, n) do
    if (string |> String.length) >= n do
      seq_split(string |> to_char_list, n, [])
    else
      []
    end
  end

  defp seq_split([], _, acc), do: acc |> Enum.reverse
  defp seq_split(chars, n, acc) do
    len = chars |> length
    cond do
      len == n ->
        seq_split([], n, [chars |> to_string | acc])
      true ->
        tail = chars |> Enum.drop(1)
        chunk = chars |> Enum.take(n) |> to_string
        seq_split(tail, n, [chunk | acc])
    end
  end

end
