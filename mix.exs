defmodule Word.Mixfile do
  use Mix.Project

  def project do
    [app: :recombinate,
     version: "0.0.2",
     elixir: "~> 1.0",
     name: "recombinate",
     source_url: "https://github.com/styx/recombinate",
     homepage_url: "https://github.com/styx/recombinate",
     deps: deps,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript
   ]
  end

  #Logger.configure_backend(:console, colors: [enabled: false])
  #config :logger, :console,
    #format: "\n$date $time [$level] $metadata$message",
    #metadata: [:user_id]
  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {App, []},
      applications: [:logger, :postgrex, :ecto]
    ]
  end

  defp escript do
    [main_module: Main]
  end

  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.6", only: :dev},
      {:mock, "~> 0.1", only: :test},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.10"}
    ]
  end
end
