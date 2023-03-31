defmodule Doumi.Phoenix.Params.MixProject do
  use Mix.Project

  @source_url "https://github.com/nallwhy/doumi_phoenix_params"
  @version "0.2.0"

  def project do
    [
      app: :doumi_phoenix_params,
      version: @version,
      elixir: "~> 1.12",
      deps: deps(),
      package: package(),
      docs: docs()
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
      {:phoenix_ecto, ">= 4.0.0"},
      {:ex_doc, "~> 0.29", only: :docs}
    ]
  end

  defp package() do
    [
      description: "A helper library that supports converting form to params and params to form",
      licenses: ["MIT"],
      maintainers: ["Jinkyou Son(nallwhy@gmail.com)"],
      files: ~w(lib mix.exs README.md LICENSE.md),
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: [
        "README.md": [title: "Overview"],
        "LICENSE.md": [title: "License"]
      ],
      api_reference: false
    ]
  end
end
