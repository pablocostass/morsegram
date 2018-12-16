defmodule RoomSupervisor do
    use Supervisor
    @moduledoc """
    Documentation for RoomSupervisor.
    """

    @doc """
    Starts the supervisor of a given room.
    """
    def start_link({room_name, _user} = args) do
        Supervisor.start_link(__MODULE__, args, name: {:global, to_string(room_name) <> "RoomSupervisor"})
    end

    @doc """
    Initializes the supervisor's children, which on this case are:
        1. A stash of the room to supervise.
        2. Said room to supervise.
        3. A periodic task that back ups the user list of the room in the stash.
    """
    def init({room_name, _user} = args) do
        child_spec = 
            [
            %{
                id: to_string(room_name) <> "Stash",
                start: {Stash, :start_link, [args]},
                restart: :transient,
                type: :worker
            },
            %{
                id: room_name,
                start: {Room, :start_link, [args]},
                restart: :transient,
                type: :worker
            },
            %{
                id: to_string(room_name) <> "Periodic",
                start: {PeriodicRoomBackup, :start_link, [room_name]},
                restart: :transient,
                type: :worker
            }]
        Supervisor.init(child_spec, [strategy: :one_for_one])
    end
end