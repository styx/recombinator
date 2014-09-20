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
      |> parse_args
      |> process
      |> IO.puts
    rescue
      _e in FunctionClauseError -> Logger.warn("Invalid params format. Should be 'word(3) word(2)'")
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

  iex> Main.parse_args(["канарейка(2)", "министр (3)"])
  "канарейка(2) министр (3)"

  iex> Main.parse_args(["канарейка(2) министр (3)"])
  "канарейка(2) министр (3)"

  iex> Main.parse_args(["-h"])
  :help

  iex> Main.parse_args(["--help"])
  :help

  """

  @spec parse_args([String.t]) :: none
  def parse_args(args) do
    options = OptionParser.parse(args, switches: [help: :boolean], aliases: [h: :help])

    case options do
      {[help: true], _, _}         -> :help
      {[], [], []}                            -> :help
      {[], words, []}              -> words |> Enum.join(" ")
      _                            -> :help
    end
  end

  @spec process([String.t] | atom) :: none
  defp process(:help) do
    IO.puts """
      Usage:
        word 'some(3) words(2)'

        `+` is allowed in place of spaces
        `()` are also can be replaced with `+` or space

      Options:
        -h, [--help]      # Show this help message and quit.

      Description:
        Recombinates words parts and checks throught database
    """
    System.halt(0)
  end

  defp process(words) when is_binary(words) do
    words
    |> Sentence.recombinate
    |> Stream.uniq
    |> Stream.filter(fn(x) -> DictionaryQueries.word_exists?(x) end)
    |> Enum.join("\n")
  end

end
