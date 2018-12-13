defmodule Room do
  use GenServer
    @moduledoc """
    Documentation for Room.
    """
    
    @doc """
    Initializes the room.
    """
    @impl true
    def init({room_name, user}) do
        {:ok, {room_name, [user]}}
    end

    @doc """
    Connects an user from the room, adding it 
    to the user list.              
    """
    @impl true
    def handle_cast({:connect, user}, users), do: {:noreply, {room_name, users ++ [user]}}
    
    @doc """
    Receives a tuple of an user and its message and 
    sends said message to every user on the room.                
    """
    @impl true  
    def handle_cast({:message, msg, user}, {room_name, users) do
        Enum.map(users, fn x -> send x, {user, msg} end)
        {:noreply, users}
    end
    
    @doc """
    Disconnects an user from the room, removing it 
    from the user list.
    """
    @impl true
    def handle_cast({:disconnect, user}, {room_name, [user]}) do
        GenServer.stop(room_name, {:shutdown, :no_users_left})
        {:stop, {:shutdown, :no_users_left}, {room_name, []}}
    end

    @impl true
    def handle_cast({:disconnect, user}, {room_name, users}) do
        new_users = Enum.reject(users, fn x -> x == user end)
        send user, :disconnected
        {:noreply, {room_name, new_users}}
    end

    @doc """
    When the room crashes.
    """
    @impl true
    def terminate(_reason, {room_name, users}) do
        Process.unregister(room_name)
    end

end
