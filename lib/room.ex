defmodule Room do
  use GenServer
    @moduledoc """
    Documentation for Room.
    """
    
    @doc """
    Initializes the room.
    """
    def init({room_name, user}) do
        pid = :global.whereis_name(user)
        send pid, {:connected, room_name} 
        {:ok, {room_name, [user]}}
    end

    @doc """
    Connects an user from the room, adding it 
    to the user list.              
    """
    def handle_cast({:connect, user}, {room_name, users}) do
        pid = :global.whereis_name(user)
        send pid, {:connected, room_name} 
        {:noreply, {room_name, users ++ [user]}}
    end
    @doc """
    Receives a tuple of an user and its message and 
    sends said message to every user on the room.                
    """
    def handle_cast({:message, msg, user}, {room_name , users}) do
        Enum.map(users, fn x -> send x, {room_name, user, msg} end)
        {:noreply, {room_name, users}}
    end
    
    @doc """
    Disconnects an user from the room, removing it 
    from the user list.
    """
    def handle_cast({:disconnect, user}, {room_name, [user]}) do
        GenServer.stop(room_name, {:shutdown, :no_users_left})
        {:stop, {:shutdown, :no_users_left}, {room_name, []}}
    end

    def handle_cast({:disconnect, user}, {room_name, users}) do
        new_users = Enum.reject(users, fn x -> x == user end)
        send {:global, user}, :disconnected
        {:noreply, {room_name, new_users}}
    end

    @doc """
    When the room crashes.
    """
    def terminate(_reason, {room_name, _users}) do
        Process.unregister(room_name)
    end

end
