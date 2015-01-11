defmodule Word do

  @moduledoc """
  Provides functions to manipulate words
  """

  @doc """
  Converts the word to the list of tokens
  of size start by sequential splitting on each
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
  def seq_split(string, start) do
    if (string |> String.length) >= start do
      seq_split(string |> to_char_list, start, [])
    else
      []
    end
  end

  defp seq_split([], _, acc), do: acc |> Enum.reverse
  defp seq_split(chars, start, acc) do
    len = chars |> length
    cond do
      len == start ->
        seq_split([], start, [chars |> to_string | acc])
      true ->
        tail = chars |> Enum.drop(1)
        chunk = chars |> Enum.take(start) |> to_string
        seq_split(tail, start, [chunk | acc])
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
    |> to_char_list
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
  ["_перу", "пер", "перу_", "пеу", "пер_у", "пру", "пе_ру", "еру", "п_еру"]
  """

  @spec logogrif(String.t) :: [String.t]
  def logogrif(<<>>), do: []
  def logogrif(word) when is_binary(word) do
    word
    |> to_char_list
    |> logogrif([], [])
    |> Stream.map(&to_string/1)
  end

  defp logogrif([], word, acc), do: ['_' ++ word | acc]
  defp logogrif([h | t], pref, acc) do
    a = pref ++ t
    b = pref ++ [h | '_'] ++ t
    logogrif(t, pref ++ [h], [a, b | acc])
  end

  @doc """
  Generates metagram patterns

  Example:
  iex> Word.metagram("барокко") |> Enum.to_list
  ["барокк_", "барок_о", "баро_ко", "бар_кко", "ба_окко", "б_рокко", "_арокко"]
  """

  @spec metagram(String.t) :: [String.t]
  def metagram(<<>>), do: []
  def metagram(word) when is_binary(word) do
    word
    |> to_char_list
    |> metagram([], [])
    |> Stream.map(&to_string/1)
  end

  defp metagram([], _word, acc), do: acc
  defp metagram([h | t], pref, acc) do
    a = pref ++ '_' ++ t
    metagram(t, pref ++ [h], [a | acc])
  end


  @doc """
  Generate corridors by words list

  Example:

  iex> Word.generate_corridors(["qwert", "yuiop", "asdfg"])
  #HashSet<["qiop", "yuit", "yert", "ydfg", "qwop", "aiop", "qweg", "yurt", "qwfg", "qwep", "aert", "yufg", "asdp", "asdt", "qdfg", "asop", "asrt", "yuig"]>

  iex> Word.generate_corridors(["word11", "wword1"])
  #HashSet<["wwod11", "wwor11", "wordd1", "woord1", "wwrd11", "word1", "worrd1"]>

  iex> words = Word.generate_corridors(["стилобат", "омлет"])
  iex> Set.member?(words, "стилет")
  true

  """

  @corridor_length 6
  @spec generate_corridors([String.t]) :: [String.t]
  def generate_corridors(words) do
    original_words = Enum.into(words, HashSet.new)

    generated_words = generate_pairs(words, [])
    |> Enum.map(&generate_corridor/1)
    |> List.flatten
    |> Enum.into(HashSet.new)

    Set.difference(generated_words, original_words)
  end

  defp generate_corridor(word1word2) do
    generate_corridor(word1word2, 1, String.length(word1word2), [])
  end

  defp generate_corridor(_word1word2, start, list_length, acc)
  when start + @corridor_length == list_length, do: acc

  defp generate_corridor(word1word2, start, list_length, acc) do
    new_corridor = word1word2 |> crop(start, list_length, @corridor_length)
    generate_corridor(word1word2, start + 1, list_length, [new_corridor | acc])
  end

  defp generate_pairs([], acc), do: acc
  defp generate_pairs([word | list], acc) do
    new_words = Enum.map(list, &([word <> &1, &1 <> word])) |> List.flatten
    generate_pairs(
      list,
      new_words ++ acc
    )
  end

  defp crop(str, start, list_length, count) do
    range1 = String.slice(str, 0, start)
    range2 = String.slice(str, start + count, list_length)

    {boundary_char, rest_of_range2} = String.next_codepoint(range2)

    case String.ends_with?(range1, boundary_char) do
      true -> [range1 <> range2, range1 <> rest_of_range2]
      false -> range1 <> range2
    end
  end

end
