defmodule Room do
    use GenServer
    @moduledoc """
    Documentation for Room.
    """

    defp global_send(pid, msg) do
        :global.whereis_name(pid)
        |> send(msg)
    end

    @doc """
    Initializes the room.
    """
    def init({room_name, user}) do
        Process.flag(:trap_exit, true)
        global_send(user, {:connected, room_name})
        {:ok, {room_name, [user]}}
    end

    @doc """
    Connects an user to the room, adding it
    to the user list.
    """
    def handle_cast({:connect, user}, {room_name, users}) do
        if Enum.find(users, fn x -> x == user end) == nil do
            global_send(user, {:connected, room_name})
            Enum.reject(users, fn x -> x == user end)
            |> Enum.map(fn x -> global_send(x, {:someone_connected, room_name, user}) end)
            {:noreply, {room_name, users ++ [user]}}
        else
            {:noreply, {room_name, users}}
        end
    end

    @doc """
    Receives a tuple of an user and its message and
    sends said message to every user on the room.
    """
    def handle_cast({:message, msg, user}, {room_name, users}) do
        if Enum.find(users, fn x -> x == user end) != nil do
            Enum.map(users, fn x -> global_send(x, {:message, room_name, user, msg}) end)
        end
        {:noreply, {room_name, users}}
    end

    @doc """
    Sends a message to a room under the given username.
    """
    def handle_cast({:list, user}, {room_name, users}) do
        global_send(user, {:list, users})
        {:noreply, {room_name, users}}
    end

    @doc """
    Disconnects an user from the room, removing it
    from the user list and notifying the rest of the users 
    on the room about it.
    The room is terminated if the user being disconnected is the last one on it.
    """
    def handle_cast({:disconnect, user}, {room_name, [user]}) do
        global_send(user, {:disconnected, room_name})
        :global.unregister_name(user)
        {:stop, :normal, {room_name, []}}
    end
    def handle_cast({:disconnect, user}, {room_name, users}) do
        new_users = Enum.reject(users, fn x -> x == user end)
        Enum.map(new_users, fn x -> global_send(x, {:someone_disconnected, room_name, user}) end)
        global_send(user, {:disconnected, room_name})
        :global.unregister_name(user)
        {:noreply, {room_name, new_users}}
    end

    @doc """
    When the room is stopped for whatever reason 
    it unregisters its name so that it can be reused in the future.
    """
    def terminate(_reason, {room_name, _users}) do
        GenServer.cast({:global, :morsegram}, {:delete_me, room_name})
        :global.unregister_name(room_name)
    end
  
  end
  