defmodule Word do

  @moduledoc """
  Provides functions to manipulate words
  """

  @doc """
  Generates sequentials splits by format 'word(n)'

  Example:

  iex> Word.parse_seq_split("канарейка(2)")
  ["ка", "ан", "на", "ар", "ре", "ей", "йк", "ка"]

  iex> Word.parse_seq_split("министр (3) ")
  ["мин", "ини", "нис", "ист", "стр"]

  """

  @spec parse_seq_split(String.t) :: [String.t]
  def parse_seq_split(encoded_string) do
    [string, n] = String.split(encoded_string, ~r/[\(\s\)]/, trim: true)
    string |> seq_split(String.to_integer(n))
  end


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

  @spec seq_split(String.t, integer) :: [String.t]
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


   @doc """

   Example:

   iex> Word.recombinate([])
   []

   iex> Word.recombinate([["no1", "no2"]])
   ["no1", "no2"]

   iex> Word.recombinate([["no1", "no2"], ["no3", "no4"]])
   ["no1no3", "no1no4", "no2no3", "no2no4"]

   iex> Word.recombinate([["no1", "no2"], ["no3", "no4"], ["no5", "no6", "no7"]])
   ["no1no3no5", "no1no3no6", "no1no3no7", "no1no4no5", "no1no4no6", "no1no4no7", "no2no3no5", "no2no3no6", "no2no3no7", "no2no4no5", "no2no4no6", "no2no4no7"]

   """

   @spec recombinate([[String.t]]) :: [String.t]
   def recombinate([]), do: []
   def recombinate([x, y]), do: merge_strings_lists(x, y)
   def recombinate([x]), do: x
   def recombinate([x, y | rest]) do
     [merge_strings_lists(x, y) | rest] |> recombinate
   end

   defp merge_strings_lists(l1, l2) do
     for x <- l1, y <- l2, do: x <> y
   end

end
