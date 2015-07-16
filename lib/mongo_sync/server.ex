defmodule MongoSync.Server do
  use GenServer
  require Logger

  def server_name, do: :mongo_sync

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: server_name)
  end

  def sync_consul, do: GenServer.call(server_name, :sync_consul)
  def sync_consul(remote_node), do: GenServer.call({server_name, remote_node}, :sync_consul)
  def update_roles, do: GenServer.call(server_name, :update_roles)
  def update_roles(remote_node), do: GenServer.call({server_name, remote_node}, :update_roles)

  def set_primary(node), do: GenServer.call(server_name, {:set_role, :primary, node})
  def set_secondary(node), do: GenServer.call(server_name, {:set_role, :secondaries, node})
  def set_arbiter(node), do: GenServer.call(server_name, {:set_role, :arbiters, node})


  def handle_call(:sync_consul, _from, state) do
    members = update_state_roles(state)
    base_key = Application.get_env(:mongo_sync, :consul_root)
    key = Path.join(base_key, "primary")
    members[:primary] |> Consul.KV.set(key)

    key = Path.join(base_key, "secondaries")
    members[:secondaries] |> Poison.encode! |> Consul.KV.set(key)

    key = Path.join(base_key, "arbiters")
    members[:arbiters] |> Poison.encode! |> Consul.KV.set(key)

    {:reply, members, members}
  end

  def handle_call(:update_roles, _from, state) do
    state = update_state_roles(state)
    {:reply, state, state}
  end


  def handle_call({:set_role, :primary, node}, _from, state) do
    state = remove_node(state, node)
    |> Keyword.put(:primary, node)
    {:reply, state, state}
  end

  def handle_call({:set_role, role, node}, _from, state) do
    state = set_nodes([node], role, state)
    {:reply, state, state}
  end


  defp update_state_roles(state) do
    members = MongoSync.ReplicaSet.members |> Enum.group_by(&(&1[:role]))
    primary = Dict.get(members, "primary", [])
    |> Enum.at(0, [node: ""])
    |> Keyword.get(:node)
    |> String.split(":")
    |> List.first
    secondaries = nodes_from_role(members, "secondary")
    arbiters = nodes_from_role(members, "arbiter")

    set_nodes(state, :arbiters, arbiters)
    |> set_nodes(:secondaries, secondaries)
    |> Keyword.put(:primary, primary)
  end


  defp remove_node(state, node) do
    state
    |> Keyword.update(:secondaries, [], &(List.delete(&1, node)))
    |> Keyword.update(:arbiters, [], &(List.delete(&1, node)))
    |> Keyword.delete(:primary, node)
    |> Keyword.put_new(:primary, "")
  end

  defp set_nodes(state, _role, []), do: state
  defp set_nodes(state, role, [node | tail]) do
    state = remove_node(state, node)
    |> Keyword.update(role, [], &(List.insert_at(&1, -1, node)))
    set_nodes(state, role, tail)
  end

  defp nodes_from_role(members, role) do
    members
    |> Dict.get(role, [])
    |> Enum.map(&(&1[:node] |> String.split(":") |> List.first))
  end


  def sync_consul_loop(nil), do: :ok
  def sync_consul_loop(interval) do
    :timer.sleep(interval)
    Logger.debug "Syncing consul"
    sync_consul
    sync_consul_loop(interval)
  end
end
