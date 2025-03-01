defmodule Room do
    use GenServer
    @moduledoc """
    Documentation for Room.
    """

    @doc """
    Starts the room with a given name and user list.
    """
    def start_link({room_name, users}) do
        GenServer.start_link(Room, {room_name, users}, name: {:global, room_name})
    end

    defp global_send(pid, msg) do
        :global.whereis_name(pid)
        |> send(msg)
    end

    defp connect_diffusion(user, users, room_name, timestamp) do
        global_send(user, {:connected, room_name, timestamp})
        Enum.reject(users, fn x -> x == user end)
        |> Enum.map(fn x -> global_send(x, {:someone_connected, room_name, user, timestamp}) end)
    end

    @doc """
    Initializes the room.
    """
    def init({room_name, _users}) do
        Process.flag(:trap_exit, true)
        users = GenServer.call({:global, to_string(room_name) <> "Stash"}, :get_list)
        timestamp = Support.timestamp(Time.utc_now())
        Enum.map(users,fn user -> connect_diffusion(user, users, room_name, timestamp) end)
        {:ok, {room_name, users}}
    end 

    @doc """
    Connects an user to the room, adding it to the user list.
    """
    def handle_cast({:connect, user}, {room_name, users}) do
        if Enum.find(users, fn x -> x == user end) == nil do
            timestamp = Support.timestamp(Time.utc_now())
            connect_diffusion(user, users, room_name, timestamp)
            {:noreply, {room_name, users ++ [user]}}
        else
            {:noreply, {room_name, users}}
        end
    end

    @doc """
    Receives a tuple of an user and its message and
    sends said message to every user on the room.
    """
    def handle_cast({:message, msg, user, timestamp}, {room_name, users}) do
        if Enum.find(users, fn x -> x == user end) != nil do
            Enum.map(users, fn x -> global_send(x, {:message, room_name, user, msg, timestamp}) end)
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
    from the user list and notifying the rest of the users on the room about it.
    The room is terminated if the user being disconnected is the last one on it.
    """
    def handle_cast({:disconnect, user}, {room_name, [user]}) do
        timestamp = Support.timestamp(Time.utc_now())
        global_send(user, {:disconnected, room_name, timestamp})
        {:stop, :normal, {room_name, []}}
    end
    def handle_cast({:disconnect, user}, {room_name, users}) do
        new_users = Enum.reject(users, fn x -> x == user end)
        timestamp = Support.timestamp(Time.utc_now())
        Enum.map(new_users, fn x -> global_send(x, {:someone_disconnected, room_name, user, timestamp}) end)
        global_send(user, {:disconnected, room_name, timestamp})
        {:noreply, {room_name, new_users}}
    end

    @doc """
    Returns the current user list from the room.
    """
    def handle_call(:backup, _from, {_room_name, users} = state) do
        {:reply, users, state}
    end

    @doc """
    When the room is stopped for whatever reason 
    it unregisters its name so that it can be reused in the future, 
    not before warning the server that the room name is now free.
    """
    def terminate(_reason, {room_name, _users}) do
        GenServer.cast({:global, :morsegram}, {:delete_me, room_name})
        :global.unregister_name(room_name)
    end

end
