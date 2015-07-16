defmodule MongoSync.ReplicaSet do
  @doc """
  Get the status of the replica set at localhost:27017 as a keyword list.
  """
  def status do
    {:ok, conn} = :mongo.connect("admin")
    {true, info} = :mongo.command(conn, {"replSetGetStatus", 1})
    flat_tuple_to_keywords(info)
  end

  def members do
    status[:members]
    |> Stream.map(&flat_tuple_to_keywords/1)
    |> Enum.map(fn x -> [node: x[:name] |> String.split(".") |> List.first, role: String.downcase(x[:stateStr])] end)
  end

  # Converts a flat tuple of keyword/value elements into a keyword list.
  defp flat_tuple_to_keywords(tuple) do
    tuple
    |> Tuple.to_list
    |> Stream.chunk(2)
    |> Enum.into([], fn x -> List.to_tuple(x) end)
  end
end
