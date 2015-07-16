defmodule MongoSync.Mixfile do
  use Mix.Project

  @version File.read!("VERSION") |> String.strip

  def project do
    [app: :mongo_sync,
     version: @version,
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     name: "MongoSync",
     docs: [readme: "README.md", main: "README",
            source_ref: "v#{@version}",
            source_url: "https://github.com/hexedpackets/mongo_sync"],

     # Hex
     description: description,
     package: package]
  end

  def application do
    [applications: [:logger, :poison, :consul],
     mod: {MongoSync.Supervisor, []}]
  end

  defp deps do
    [
      {:mongodb, github: "comtihon/mongodb-erlang"},
      {:consul, github: "hexedpackets/exconsul"},
      {:poison, "~> 1.2"},
    ]
  end

  defp description do
    """
    Syncs MongoDB replication members with Consul.
    """
  end

  defp package do
    [contributors: ["William Huba"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/hexedpackets/mongo_sync"},
     files: ~w(mix.exs README.md LICENSE lib VERSION)]
  end
end
