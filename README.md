MongoSync
=========

Elixir applications for syncing MongoDB replication information with Consul.

### Installation
Add MongoSync as a dependency in your mix.exs file

```elixir
def application do
  [applications: [:mongo_sync]]
end

defp deps do
  [
    {:mongo_sync, github: "hexedpackets/mongo_sync"}
  ]
end
```

### Configuration
```elixir
# Indicates the key in Consul to store members under
config :mongo_sync, :consul_root, "services/db"

# Whether to regularly sync with Consul or only have syncing manually started
config :mongo_sync, :auto_sync, true

# How often to sync with Consul when :auto_sync is enabled
config :mongo_sync, :interval, 10000

# MongoDB connection info
config :mongo_sync, :mongo_host, '127.0.0.1'
config :mongo_sync, :mongo_port, 27017
```

These can also be configured with the environmental variables `MONGO_CONSUL_ROOT`, `MONGO_AUTO_SYNC`, `MONGO_SYNC_INTERVAL`, `MONGO_HOST`, and `MONGO_PORT` when using mongo_sync as a standalone application.
