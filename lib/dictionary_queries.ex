defmodule DictionaryQueries do
  import Ecto.Query

  def word_exists?(word) do
    query = from d in Dictionary,
          where: d.word == ^word,
         select: count(d.id)

    [count] = Repo.all(query)
    count > 0
  end
end
