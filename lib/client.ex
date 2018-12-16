defmodule Client do
    @moduledoc """
    Documentation for Client.
    """

    @doc """
    Given a topic it searches for a room that matches it.
    If it finds one the client will join the room, otherwise
    first the room will be created.
    """
    def search_room(topic, username) do
        if Enum.find(:global.registered_names(), fn x -> x == username end) == nil do
            pid = spawn_link(fn -> listen() end)
            :global.register_name(username, pid)
        end
        GenServer.cast({:global, :morsegram}, {:search, topic, username})
    end

    @doc """
    Sends a message to a room under the given username.
    """
    def send_message(message, room, username) do
        timestamp = Support.timestamp(Time.utc_now)
        GenServer.cast({:global, room}, {:message, message, username, timestamp})
    end

    @doc """
    List the users from a given room under a username.
    """
    def list_users(room, username) do
        GenServer.cast({:global, room}, {:list, username})
    end

    @doc """
    Disconnects an user from a given room.
    """
    def disconnect_from(room, username) do
        GenServer.cast({:global, room}, {:disconnect, username})
    end

    defp listen() do
        receive do
            {:message, room, user, msg, timestamp} ->
                IO.write("[#{Support.color_this(timestamp, :light_cyan)}] [#{room}] #{user}: #{msg}")
            {:connected, room, timestamp} ->
                IO.puts("[#{Support.color_this(timestamp, :light_cyan)}] [Connected to room #{room}]")
            {:list, users} ->
                IO.inspect users
            {:someone_connected, room, user, timestamp} ->
                IO.puts("[#{Support.color_this(timestamp, :light_cyan)}] [User #{user} has connected to the room #{room}]")
            {:someone_disconnected, room, user, timestamp} ->
                IO.puts("[#{Support.color_this(timestamp, :light_cyan)}] [User #{user} has disconnected from the room #{room}]")
            {:disconnected, room, timestamp} ->
                IO.puts("[#{Support.color_this(timestamp, :light_cyan)}] [Disconnected from room #{room}]")
        end
        listen()
    end

end
