defmodule Main do
  require Logger

  @moduledoc """
  Main module
  """

  @doc """
  Main function (:
  """

  @spec main(OptionParser.argv) :: none
  def main(args) do
    try do
      args
      |> Enum.map(&String.downcase/1)
      |> parse_args
      |> process
    rescue
      _e in FunctionClauseError -> process(:help)
    end
  end

  @doc """
  Parses function arguments

  Example:

  iex> Main.parse_args(["-d", "канарейка(2)", "министр (3)"])
  {:dismemberment, "канарейка(2) министр (3)"}

  iex> Main.parse_args(["--dismemberment", "канарейка(2) министр (3)"])
  {:dismemberment, "канарейка(2) министр (3)"}

  iex> Main.parse_args(["-h"])
  :help

  iex> Main.parse_args(["--help"])
  :help

  iex> Main.parse_args(["-a", "аканарейк"])
  {:anagram, "аканарейк"}

  iex> Main.parse_args(["--anagram", "аканарейк"])
  {:anagram, "аканарейк"}

  iex> Main.parse_args(["--insert", "new_word"])
  {:insert, "new_word", ""}

  iex> Main.parse_args(["-i", "new_word", "some_info"])
  {:insert, "new_word", "some_info"}

  iex> Main.parse_args(["-r", "word"])
  {:remove, "word"}

  iex> Main.parse_args(["-l", "ксения"])
  {:logogrif, "ксения"}

  iex> Main.parse_args(["--logogrif", "кения"])
  {:logogrif, "кения"}

  iex> Main.parse_args(["-m", "барокко"])
  {:metagram, "барокко"}

  iex> Main.parse_args(["--metagram", "марокко"])
  {:metagram, "марокко"}

  iex> Main.parse_args(["-c", "скальп тренер"])
  {:corridor, "скальп тренер"}

  iex> Main.parse_args(["--corridor", "скальп тренер"])
  {:corridor, "скальп тренер"}

  """

  @spec parse_args(OptionParser.argv) :: none
  def parse_args(args) do
    options = OptionParser.parse(args,
      switches: [
        help: :boolean,
        anagram: :boolean,
        dismemberment: :boolean,
        logogrif: :boolean,
        metagram: :boolean,
        insert: :boolean,
        find: :boolean,
        remove: :boolean,
        corridor: :boolean
      ],
      aliases: [
        h: :help,
        a: :anagram,
        d: :dismemberment,
        l: :logogrif,
        m: :metagram,
        i: :insert,
        f: :find,
        r: :remove,
        c: :corridor
      ]
    )

    case options do
      {[help: true], _, _}                            -> :help
      {[anagram: true], [word], _}                    -> {:anagram, word}
      {[dismemberment: true], words, []}              -> {:dismemberment, words |> Enum.join(" ")}
      {[logogrif: true], [word], []}                  -> {:logogrif, word}
      {[metagram: true], [word], []}                  -> {:metagram, word}
      {[insert: true], [word], []}                    -> {:insert, word, ""}
      {[insert: true], [word, info], []}              -> {:insert, word, info}
      {[find: true], [word], []}                      -> {:find, word}
      {[remove: true], [word], []}                    -> {:remove, word}
      {[corridor: true], words, []}                   -> {:corridor, words |> Enum.join(" ")}
      _                                               -> :help
    end
  end

  @spec process({atom, String.t} | atom) :: none
  defp process(:help) do
    IO.puts """
      Usage:

      Options:
        -h, [--help]               # Show this help message and quit.

        -a, [--anagram]            # Generates possible anagrams and
            'word'                 # and filters throught Dictionary

          Description:
            Recombinates word chars and checks them for validity
            throught database

        -d, [--dismemberment]      # Builds a words by dismemberment
            'some(3) words(2)'     # alghorithm and filters through
                                   # Dictionary
          Description:
            Recombinates words parts and checks them for validity
            throught database

            `+` is allowed in place of spaces
            `()` are also can be replaced with `+` or space

        -l, [--logogrif]           # Builds logogrifos and checks
            'word'                 # through dictionary

        -m, [--metagram]           # Builds metagrams and checks
            'word'                 # through dictionary

        -c, [--corridor]           # Builds corridors and checks
            'word1 word2 word3'    # through dictionary

        -i, [--insert]             # Inserts new word with some info
          'word' 'some info'

          Description:
            Inserts new word if it's not present in DB else shows a warning

        -f, [--find]               # Finds the word by pattern and shows info
          'word'

        -r, [--remove]             # Removes the word and shows what was removed
          'word'

          Description:
            Removes a word by ID
    """
    System.halt(0)
  end

  defp process({:dismemberment, words}) when is_binary(words) do
    words
    |> Sentence.recombinate
    |> Stream.uniq
    |> Stream.filter(&DictionaryQueries.word_exists?/1)
    |> PP.print_list
  end

  defp process({:anagram, word}) do
    word
    |> Word.sort
    |> DictionaryQueries.anagrams
    |> Stream.uniq
    |> PP.print_list
  end

  defp process({:logogrif, word}) do
    word
    |> Word.logogrif
    |> DictionaryQueries.find_all(word)
    |> PP.print_words_pairs(word)
  end

  defp process({:metagram, word}) do
    word
    |> Word.metagram
    |> DictionaryQueries.find_all(word)
    |> PP.print_words_pairs(word)
  end

  defp process({:find, word}) do
    word
    |> DictionaryQueries.find_words
    |> Stream.map(&Word.pp/1)
    |> PP.print_list
  end

  defp process({:insert, word, info}) do
    case DictionaryQueries.insert_word(word, info) do
      {:ok, _} -> Logger.info("Insertion finished successfully")
      :exists  -> Logger.warn("Word already exists. Update it's info instead")
    end
  end

  defp process({:corridor, words}) do
    words
    |> Sentence.generate_corridors
    |> Stream.uniq
    |> Stream.filter(&(String.length(&1) > 3))
    |> Stream.filter(&DictionaryQueries.word_exists?/1)
    |> Enum.sort(&(String.length(&2) > String.length(&1)))
    |> PP.print_list
  end

  defp process({:remove, word}) do
    word
    |> DictionaryQueries.find_words
    |> Stream.map(&Word.pp/1)
    |> Stream.with_index
    |> Enum.into(%{}, fn {word, n} -> {n, word} end)
    |> remove_cycle
  end

  defp remove_cycle(words) do
    if Dict.size(words) > 0 do
      words
      |> Dict.delete(words |> PP.select_word_prompt("Enter ID for removal: "))
      |> remove_cycle
    end
  end

end
