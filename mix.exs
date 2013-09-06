defmodule Coleoid.Mixfile do
  use Mix.Project

  def project do
    [ app: :coleoid,
      version: "0.0.1",
      dynamos: [Coleoid.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/coleoid/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { Coleoid, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :continuum, github: "meh/continuum" },
      { :json,   github: "cblage/elixir-json"},
      { :exredis, github: "artemeff/exredis" },
      { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" } ]
  end
end
