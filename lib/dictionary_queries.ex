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
