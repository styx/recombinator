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

end
