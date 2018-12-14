defmodule Client do
    @moduledoc """
    Documentation for Morsegram.
    """
  
    @doc """
    Given a topic it searches for a room that matches it.
    If it finds one the client will join the room, otherwise 
    first the room will be created.
    """

    def search_room(topic, username) do
        if Enum.find(:global.registered_names(), fn x -> x == username end) == nil do
            pid = spawn_link(Client, :listen, [])
            :global.register_name(username, pid)
        end
        GenServer.cast({:global, :morsegram}, {:search, topic, username})
    end

    def send_message(message, username, room) do
        GenServer.cast({:global, room}, {:message, message, username})        
    end

    def disconnect_from(room, username) do
        GenServer.cast({:global, room}, {:disconnect, username})
    end

    def listen() do
        receive do
            {:message, room, user, msg} -> 
                IO.puts("[#{room}] #{user}: #{msg}")
                listen()
            {:connected, room} -> 
                IO.puts("[Connected to room #{room}]")
                listen()
            {:someone_connected, room, user} ->
                IO.puts("[User #{user} has connected to the room #{room}]")
                listen()
            {:someone_disconnected, room, user} ->
                IO.puts("[User #{user} has disconnected from the room #{room}]")
                listen()
            {:disconnected, room} -> 
                IO.puts("[Disconnected from room #{room}]")
        end
    end
    
  end
  