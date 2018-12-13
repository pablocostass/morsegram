defmodule Leader do
    @moduledoc """
    Documentation for Morsegram.
    """
  
    @doc """
    Given a topic it searches for a room that matches it.
    If it finds one the client will join the room, otherwise 
    first the room will be created.
    """
    def search_room(room) do
      :world
    end

    def spawn_room(room), do: :ok

    def init, do: :ok
    
    def terminate, do: :ok

    def start, do: :ok
  end
  