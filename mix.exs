defmodule Cobwebhook.MixProject do
  use Mix.Project

  def project do
    [
      app: :cobwebhook,
      version: "0.1.0",
      deps: [
        {:plug, "~> 1.6.1"},
        {:poison, "~> 3.1"}
      ]
    ]
  end
end
