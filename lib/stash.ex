defmodule Stash do
  use GenServer

  def start_link({room_name, users}) do
    GenServer.start_link(Stash, {room_name, users}, name: {:global, to_string(room_name) <> "Stash"})
  end

  #Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_call(:get_list, _from, {_room_name, users} = state) do
    {:reply, users, state}
  end

  def handle_cast(:backup,{room_name, _users}) do
    new_state = GenServer.call({:global, room_name}, :backup)
    {:noreply, {room_name, new_state}}
  end
end
