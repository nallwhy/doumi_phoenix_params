defmodule Doumi.Phoenix.Params.MixProject do
  use Mix.Project

  def project do
    [
      app: :doumi_phoenix_params,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, ">= 0.18.12"},
      {:phoenix_ecto, ">= 4.0.0"}
    ]
  end
end
