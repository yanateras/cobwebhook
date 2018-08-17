defmodule Cobwebhook.MixProject do
  use Mix.Project

  def project do
    [
      app: :cobwebhook,
      deps: [
        {:cowboy, "~> 2.4.0", only: :dev},
        {:ex_doc, "~> 0.18.0", only: :dev, runtime: false},
        {:plug, "~> 1.6.1"},
        {:poison, "~> 3.1"}
      ],
      docs: [
        main: "readme",
	extras: ["README.md"]
      ],
      package: [
        description: "Set of webhook Plug middleware",
	files: ["lib", "mix.exs", "README.md"],
	licenses: ["CC0-1.0"],
	links: %{"GitHub" => "https://github.com/serokell/cobwebhook"},
	maintainers: ["Yegor Timoshenko"]
      ],
      version: "0.1.0"
    ]
  end
end
