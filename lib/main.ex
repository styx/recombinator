defmodule Main do
  require Logger

  @moduledoc """
  Main module
  """

  @doc """
  Main function (:
  """

  def main(args) do
    try do
      args
      |> parse_args
      |> process
    rescue
      _e in FunctionClauseError -> Logger.warn("Invalid params format. Should be 'word(3) word(2)'")
    end
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

  def parse_args(args) do
    options = OptionParser.parse(args, switches: [help: :boolean], aliases: [h: :help])

    case options do
      {[help: true], _, _}         -> :help
      {[], [], []}                            -> :help
      {[], words, []}              -> words |> Enum.join(" ")
      _                            -> :help
    end
  end

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
    |> Enum.join("\n")
    |> IO.puts
  end

end
