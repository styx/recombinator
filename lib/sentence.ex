defmodule Sentence do

  @moduledoc """
  Provides functions to manipulate words
  """

  @doc """
  Generates sequentials splits by format 'word(n)'

  Example:

  iex> Sentence.seq_split("канарейка(2)")
  [["ка", "ан", "на", "ар", "ре", "ей", "йк", "ка"]]

  iex> Sentence.seq_split("министр (3) ")
  [["мин", "ини", "нис", "ист", "стр"]]

  iex> Sentence.seq_split("канарейка(2) + министр (3) ")
  [["ка", "ан", "на", "ар", "ре", "ей", "йк", "ка"], ["мин", "ини", "нис", "ист", "стр"]]

  """

  @spec seq_split(String.t) :: [String.t]
  def seq_split(encoded_string) do
    pairs_list = String.split(encoded_string, ~r/[()+\s]/, trim: true)
    seq_split(pairs_list, [])
  end

  defp seq_split([], accumulator), do: Enum.reverse(accumulator)
  defp seq_split([word, n | rest], accumulator) do
    rest |>
      seq_split(
        [word |> Word.seq_split(String.to_integer(n)) | accumulator]
      )
  end

end
