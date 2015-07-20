use Mix.Config

# Indicates the key in Consul to store members under
config :mongo_sync, :consul_root, "services/db"

# Whether to regularly sync with Consul or only have syncing manually started
config :mongo_sync, :auto_sync, false

# How often to sync with Consul when :auto_sync is enabled
config :mongo_sync, :interval, 10000
