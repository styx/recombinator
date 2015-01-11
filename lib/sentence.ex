defmodule Sentence do

  @moduledoc """
  Provides functions to manipulate words
  """

  @doc """
  Trims and splits a sentece by whitespaces, () and +
  to the words list

  Example:

  iex> Sentence.to_words_list("(xxx)yyy+zzz")
  ["xxx", "yyy", "zzz"]
  """

  def to_words_list(sentence) do
    String.split(sentence, ~r/[()+\s]/, trim: true)
  end

  @doc """
  Generates sequentials splits by format 'word(n) \n word (n) + word(n)'
  with any combination of \s and ?+ in places of spaces, \n and ?+.

  Example:

  iex> Sentence.seq_split("канарейка(2)")
  [["ка", "ан", "на", "ар", "ре", "ей", "йк", "ка"]]

  iex> Sentence.seq_split("министр (3) ")
  [["мин", "ини", "нис", "ист", "стр"]]

  iex> Sentence.seq_split("канарейка(2) + министр (3) ")
  [["ка", "ан", "на", "ар", "ре", "ей", "йк", "ка"], ["мин", "ини", "нис", "ист", "стр"]]

  """

  @spec seq_split(String.t) :: [[String.t]]
  def seq_split(sentence) do
    pairs_list = sentence |> to_words_list
    seq_split(pairs_list, [])
  end

  defp seq_split([], accumulator), do: Enum.reverse(accumulator)
  defp seq_split([word, n | rest], accumulator) do
    rest |>
      seq_split(
        [word |> Word.seq_split(String.to_integer(n)) | accumulator]
      )
  end

  @doc """
  Parses a sentence to words and count options and recombinates then

  Example:

  iex> Sentence.recombinate("новость(3) + рахит(2) + сгущенка(3) + изобилие(2)") |> hd
  "новрасгуиз"

  iex> Sentence.recombinate("новость(3) + рахит(2) + сгущенка(3) + изобилие(2)") |> List.last
  "стьитнкаие"

  iex> Sentence.recombinate("новость(3) + рахит(2) + сгущенка(3) + изобилие(2)") |> length
  840
  """

  @spec recombinate(String.t) :: [String.t]
  def recombinate(sentence) do
    seq_split(sentence) |> Word.recombinate
  end

  @doc """
  Generates corridors see Word.generate_corridors/1
  """

  def generate_corridors(sentence) do
    sentence
    |> Sentence.to_words_list
    |> Word.generate_corridors
  end

end
