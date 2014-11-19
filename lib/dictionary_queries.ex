defmodule DictionaryQueries do
  import Ecto.Query

  def word_exists?(word) do
    query = from d in Dictionary,
          where: d.word == ^word,
         select: count(d.id)

    [count] = Repo.all(query)
    count > 0
  end

  def anagrams(word) do
    query = from d in Dictionary,
          where: d.anagram == ^word,
         select: d.word

    Repo.all(query)
  end

  def all do
    query = from d in Dictionary,
         select: d

    Repo.all(query)
  end

  def find_words(word) do
    query = from d in Dictionary,
         select: d,
         where: ilike(d.word, ^word)

    Repo.all(query)
  end

  def find_all(patterns, word) do
    patterns
    |> Stream.flat_map(&find_words/1)
    |> Stream.map(&to_string/1)
    |> Stream.filter(fn(dict_word) -> dict_word != word end)
    |> Stream.uniq
  end

  def insert_word(word, info) do
    word    = word |> String.downcase
    anagram = word |> Word.sort

    unless word_exists?(word) do
      word = %Dictionary{word: word, info: info, anagram: anagram}
      |> Repo.insert
      {:ok, word}
    else
      :exists
    end
  end
end
