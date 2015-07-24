defmodule MongoSync do
  @doc """
  Returns the host name or address set in the config for MongoDB, as a char list.
  """
  def host, do: Application.get_env(:mongo_sync, :mongo_host)

  @doc """
  Return the port set in the config for MongoDB.
  """
  def port, do: Application.get_env(:mongo_sync, :mongo_port)
end
