defmodule FinancialSystem.Mixfile do
  use Mix.Project

  def project do
    [
      app: :financial_system,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),

      # Docs
      name: "FinancialSystem",
      source_url: "https://github.com/lcpojr/financial-system/",
      homepage_url: "https://github.com/lcpojr/financial-system/",

      # Coverage test
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpotion, :poison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:decimal, "~> 1.0"}, # Decimal
      {:httpotion, "~> 3.1.0"}, # HTTP
      {:poison, "~> 3.1"}, # JSON
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}, # Documentation
      {:excoveralls, "~> 0.8", only: :test} # Coverage test
    ]
  end
end
