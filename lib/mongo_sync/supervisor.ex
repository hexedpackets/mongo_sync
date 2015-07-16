defmodule MongoSync.Supervisor do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    consul_sync_interval = Application.get_env(:mongo_sync, :interval)

    children = [
      worker(MongoSync.Server, [[primary: "", secondaries: [], arbiters: []]]),
      worker(Task, [MongoSync.Server, :sync_consul_loop, [consul_sync_interval]]),
    ]

    opts = [strategy: :one_for_one, name: MongoSync.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
