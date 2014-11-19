defmodule PP do
  def print_list(list) do
    Enum.each(list, &IO.puts/1)
  end

  def print_hash(hash) do
    hash
    |> Stream.map(fn {i, w} -> "#{i}) #{w}" end)
    |> print_list
  end

  def print_words_pairs(list, word) do
    list
    |> Stream.map(fn(dict_word) -> "#{word} #{dict_word}" end)
    |> print_list
  end

  def select_word_prompt(words, prompt) do
    words |> print_hash

    IO.puts "Ctrl+D - to exit\n"
    str_id = IO.gets prompt
    {id, _} = str_id |> Integer.parse
    id
  end
end
