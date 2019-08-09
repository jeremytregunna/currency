defmodule Currency.MixProject do
  use Mix.Project

  def project do
    [
      app: :currency,
      version: "1.0.0",
      elixir: "~> 1.8",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:decimal, "~> 1.8"},
      {:jason, "~> 1.1.2"},
      {:ex_doc, "~> 0.21.1", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: :currency,
      description: "ISO 4217 currency library",
      files: ~w(lib priv mix.exs README.md LICENSE LICENSE-2.0),
      maintainers: ["Jeremy Tregunna"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/jeremytregunna/currency.git",
        "Docs" => "https://hexdocs.pm/currency"
      }
    ]
  end
end
