defmodule Leader do
  use GenServer
    @moduledoc """
    Documentation for Morsegram.
    """
  
    @doc """
    Given a topic it searches for a room that matches it.
    If it finds one the client will join the room, otherwise 
    first the room will be created.
    """
    def init(state), do: {:ok, state}
    
    def handle_call({:register, _username}), do: :ok

    def handle_cast({:search, topic, user}, state) do
      room = Enum.find(state, fn x -> x == topic end)
      case room do
        nil ->
          GenServer.start_link(Room, {topic, user}, name: {:global, topic})
          {:noreply, state ++ [topic]}
        _ -> 
          GenServer.cast({:global, topic}, {:connect, user})
          {:noreply, state}
      end
    end
    
    def terminate, do: :ok

    def start do
      GenServer.start_link(Leader, [], name: {:global, :morsegram})
    end
  end
  