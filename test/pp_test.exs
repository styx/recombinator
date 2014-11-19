defmodule PPTest do
  use ExUnit.Case
  import Mock

  test_with_mock "print_list", IO, [puts: fn (x) -> x end] do
    PP.print_list([1,2,"3"])
    assert called IO.puts 1
    assert called IO.puts 2
    assert called IO.puts "3"
  end

  test_with_mock "print_hash", IO, [puts: fn (x) -> x end] do
    PP.print_hash(%{1 => "word", 2 => "word 2"})
    assert called IO.puts "1) word"
    assert called IO.puts "2) word 2"
  end

  test_with_mock "print_words_pairs", IO, [puts: fn (x) -> x end] do
    PP.print_words_pairs(["word1", "word2"], "base_word")
    assert called IO.puts "base_word word1"
    assert called IO.puts "base_word word2"
  end

  test_with_mock "select_word_prompt", IO, [puts: fn (x) -> x end, gets: fn(x) -> "42" end] do
    assert PP.select_word_prompt(%{1 => "word"}, "Enter ID for removal: ") == 42

    assert called IO.gets "Enter ID for removal: "
  end
end
