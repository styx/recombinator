defmodule Main do
  require Logger

  @moduledoc """
  Main module
  """

  @doc """
  Main function (:
  """

  @spec main([String.t]) :: none
  def main(args) do
    init

    try do
      args
      |> Enum.map(&String.downcase/1)
      |> parse_args
      |> process
    rescue
      _e in FunctionClauseError -> process(:help)
    end
  end

  @spec init :: none
  defp init do
    import Supervisor.Spec
    tree = [worker(Repo, [])]
    opts = [name: Simple.Sup, strategy: :one_for_one]
    Supervisor.start_link(tree, opts)
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
  """

  @spec parse_args([String.t]) :: none
  def parse_args(args) do
    options = OptionParser.parse(args,
      switches: [
        help: :boolean,
        anagram: :boolean,
        dismemberment: :boolean,
        logogrif: :boolean,
        insert: :boolean,
        find: :boolean,
        remove: :boolean
      ],
      aliases: [
        h: :help,
        a: :anagram,
        d: :dismemberment,
        l: :logogrif,
        i: :insert,
        f: :find,
        r: :remove
      ]
    )

    case options do
      {[help: true], _, _}                            -> :help
      {[anagram: true], [word], _}                    -> {:anagram, word}
      {[dismemberment: true], words, []}              -> {:dismemberment, words |> Enum.join(" ")}
      {[logogrif: true], [word], []}                  -> {:logogrif, word}
      {[insert: true], [word], []}                    -> {:insert, word, ""}
      {[insert: true], [word, info], []}              -> {:insert, word, info}
      {[find: true], [word], []}                      -> {:find, word}
      {[remove: true], [word], []}                    -> {:remove, word}
      _                                               -> :help
    end
  end

  @spec process([String.t] | atom) :: none
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
            'word'                 # Through dictionary

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
    |> print_list
  end

  defp process({:anagram, word}) do
    word
    |> Word.sort
    |> DictionaryQueries.anagrams
    |> Stream.uniq
    |> print_list
  end

  defp process({:logogrif, word}) do
    word
    |> Word.logogrif
    |> Stream.flat_map(&DictionaryQueries.find_words/1)
    |> Stream.filter(fn(dict_word) -> dict_word != word end)
    |> Stream.uniq
    |> print_list
  end

  defp process({:find, word}) do
    word
    |> DictionaryQueries.find_words
    |> Stream.map(&Word.pp/1)
    |> print_list
  end

  defp process({:insert, word, info}) do
    case DictionaryQueries.insert_word(word, info) do
      {:ok, _} -> Logger.info("Insertion finished successfully")
      :exists  -> Logger.warn("Word already exists. Update it's info instead")
    end
  end

  defp process({:remove, word}) do
    process({:find, word})
    IO.gets "Enter ID for removal: "
    Logger.error "Not implemented yet"
  end

  defp print_list(list) do
    Enum.each(list, &IO.puts/1)
  end

end
