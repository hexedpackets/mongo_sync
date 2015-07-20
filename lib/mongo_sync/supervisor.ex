defmodule MongoSync.Supervisor do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(MongoSync.Server, [[primary: "", secondaries: [], arbiters: []]]),
    ]

    consul_sync_interval = Application.get_env(:mongo_sync, :interval)
    case Application.get_env(:mongo_sync, :auto_sync) do
      true -> children = children ++ [worker(Task, [MongoSync.Server, :sync_consul_loop, [consul_sync_interval]])]
      _ -> :ok
    end

    opts = [strategy: :one_for_one, name: MongoSync.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
