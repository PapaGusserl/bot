defmodule Bot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bot,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [
                      :logger,
                      :poison,
                      :distillery,
                      :mailgun,
                      :edeliver 
                    ],
                    mod: {Bot, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
       {   :poison, "~> 1.4"}, 
      {:httpoison, "~> 1.0"},
      {:distillery, "~> 1.4"},
      {:mailgun, "~> 0.1.2"},
      {:edeliver, "~> 1.4"}
    ]
  end
end
