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

    defp create_room(room), do: :ok

    @doc """
    Deletes a room if the caller is the last one on it.
    """
    def delete_room(room), do: ok
  end
  