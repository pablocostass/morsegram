defmodule Room do
use GenServer
    @moduledoc """
    Documentation for Room.
    """
    
    @doc """
    Initializes the room.
    """
    def init({room_name, user}) do
        {:ok, {room_name, [user]}}
    end

    @doc """
    Connects an user from the room, adding it 
    to the user list.              
    """
    def handle_cast({:connect, user}, users), do: {:noreply, {room_name, users ++ [user]}}
    
    @doc """
    Receives a tuple of an user and its message and 
    sends said message to every user on the room.                
    """    
    def handle_cast({:message, user, msg}, {room_name, users) do
        Enum.map(users, fn x -> send x, {user, msg} end)
        {:noreply, users}
    end
    
    @doc """
    Disconnects an user from the room, removing it 
    from the user list.              
    """   
    def handle_cast({:disconnect, user}, {room_name, users}) do
        new_users = Enum.reject(users, fn x -> x == user end)
        {:noreply, {room_name, new_users}}
    end

    @doc """
    Recovers the state of the room.
    """
    def handle_call(:get_state, _from, state), do: {:reply, state, state}
    
    @doc """
    When the room crashes.
    """
    def terminate(_reason, {room_name, users}) do
        Process.unregister(room_name)
    end

end
