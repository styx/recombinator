defmodule Mix.Tasks.Exec do
  use Mix.Task

  @shortdoc "Runs application"

  @doc """
  Runs application and passes params to the main function
  """

  def run(args) do
    Main.main(args)
  end

end
