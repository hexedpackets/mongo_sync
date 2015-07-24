use Mix.Config

# Indicates the key in Consul to store members under
config :mongo_sync, :consul_root, System.get_env("MONGO_CONSUL_ROOT") || "services/db"

# Whether to regularly sync with Consul or only have syncing manually started
auto_sync = case System.get_env("MONGO_AUTO_SYNC") do
  nil -> false
  val -> String.to_atom(val)
end
config :mongo_sync, :auto_sync, auto_sync

# How often to sync with Consul when :auto_sync is enabled
interval = case System.get_env("MONGO_SYNC_INTERVAL") do
  nil -> 10000
  val -> String.to_integer(val)
end
config :mongo_sync, :interval, interval

# Mongo server connection params
host = case System.get_env("MONGO_HOST") do
  nil -> '127.0.0.1'
  val -> to_char_list(val)
end
config :mongo_sync, :mongo_host, host
port = case System.get_env("MONGO_PORT") do
  nil -> 27017
  val -> String.to_integer(val)
end
config :mongo_sync, :mongo_port, port
