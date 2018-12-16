defmodule Stash do
  use GenServer
  @moduledoc """
  Documentation for Stash.
  """

  @doc """
  Starts the stash for a given room with its user list.
  """
  def start_link({room_name, users}) do
    GenServer.start_link(Stash, {room_name, users}, name: {:global, to_string(room_name) <> "Stash"})
  end

  #Callbacks

  @doc """
  Initializes the stash.
  """
  def init(state) do
    {:ok, state}
  end

  @doc """
  Recovers the list of users from the stash.
  """
  def handle_call(:get_list, _from, {_room_name, users} = state) do
    {:reply, users, state}
  end

  @doc """
  Stores the current user list returned from the room.
  """
  def handle_cast(:backup, {room_name, _users}) do
    new_state = GenServer.call({:global, room_name}, :backup)
    {:noreply, {room_name, new_state}}
  end
end
