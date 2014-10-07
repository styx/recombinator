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

  @doc """
  Generates permutations for List of elements or a String

  Examples:

  iex> Word.permute 'abc'
  ['abc', 'bac', 'bca', 'acb', 'cab', 'cba']

  iex> Word.permute "abc"
  ["abc", "bac", "bca", "acb", "cab", "cba"]

  """

  @spec permute(String.t) :: [String.t]
  def permute(<<>>), do: []
  def permute(binary) when is_binary(binary) do
    binary
    |> String.to_char_list
    |> permute
    |> Enum.map(&List.to_string/1)
  end

  @spec permute([elem]) :: [[elem]] when elem: var
  def permute([]), do: [[]]
  def permute([a|as]) do
    for bs <- permute(as), {bs1, bs2} <- splits(bs), do: bs1 ++ [a|bs2]
  end

  @spec splits([elem]) :: [{[elem], [elem]}] when elem: var
  defp splits([]), do: [{[], []}]
  defp splits(al = [a|as]) do
    [{[],al} | (for {bs, cs} <- splits(as), do: {[a|bs],cs})]
  end

  @doc """
  Sorts word chars

  Example:

  iex> Word.sort("гбв")
  "бвг"
  """

  def sort(word) when is_binary(word) do
    word
    |> to_char_list
    |> Enum.sort
    |> to_string
  end

  @doc """
  Pretty printer

  Example:

  iex> Word.pp(%Dictionary{id: 1, word: "test", info: "info", anagram: "estt"})
  "1\ttest\tinfo"
  """

  @spec pp(Dictionary.t) :: String.t
  def pp(word) do
    "#{word.id}\t#{word.word}\t#{word.info}"
  end

  @doc """
  Generates logogrif patterns

  Example:
  iex> Word.logogrif("перу") |> Enum.to_list
  ["_перу", "перу_", "пер", "пер_", "пеу", "пе_у", "пру", "п_ру", "еру", "_еру"]
  """

  @spec logogrif(String.t) :: [String.t]
  def logogrif(<<>>), do: []
  def logogrif(word) when is_binary(word) do
    word
    |> to_char_list
    |> logogrif([], [])
    |> Stream.map(&to_string/1)
  end

  defp logogrif([], word, acc), do: ['_' ++ word, word ++ '_' | acc]
  defp logogrif([h | t], pref, acc) do
    a = pref ++ t
    b = pref ++ '_' ++ t
    logogrif(t, pref ++ [h], [a, b | acc])
  end

end
