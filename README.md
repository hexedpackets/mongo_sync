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
There are two configurable parameters. `:consul_root` indicates the key in Consul to store members under. `:interval` indicates how often to sync.

```elixir
config :mongo_sync, :consul_root, "services/db"
config :mongo_sync, :interval, 10000
```
