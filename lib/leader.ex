defmodule Leader do
  use GenServer
  @moduledoc """
  Documentation for Leader.
  """

  @doc """
  Sets the server state.
  """
  def init(state) do
    MainSupervisor.start_link([])
    {:ok, state}
  end

  @doc """
  Handles the search of a room done by an user and connects them to it.
  The room is created if it did not exist.
  """
  def handle_cast({:search, topic, user}, state) do
    room = Enum.find(state, fn x -> x == topic end)
    case room do
      nil ->
        MainSupervisor.start_child({topic, [user]})
        {:noreply, state ++ [topic]}
      _ ->
        GenServer.cast({:global, topic}, {:connect, user})
        {:noreply, state}
    end
  end

  @doc """
  Deletes a room from the server state.
  """
  def handle_cast({:delete_me, topic}, state) do
    pid = :global.whereis_name(to_string(topic) <> "RoomSupervisor")
    DynamicSupervisor.terminate_child(MainSupervisor, pid)
    {:noreply, state -- [topic]}
  end

  @doc """
  Invoked when the server goes down.
  """
  def terminate, do: :ok

  @doc """
  Initializes the server and registers it globally under the atom :morsegram.
  """
  def start do
    GenServer.start_link(Leader, [], name: {:global, :morsegram})
  end
end
