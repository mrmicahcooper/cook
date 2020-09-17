defmodule Cook.MixProject do
  use Mix.Project

  def project do
    [
      app: :cook_ex,
      version: "0.1.0",
      elixir: "~> 1.7.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  def escript() do
    [
      main_module: Cook,
      name: "recipes_to_json",
      app: nil,
      strip_beams: true,
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:nimble_parsec, "~> 0.6"}
    ]
  end
end
