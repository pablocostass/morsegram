defmodule RoomSupervisor do
    use Supervisor
    
    def start_link(args) do
        Supervisor.start_link(__MODULE__, args)
    end

    def init({room_name, _user} = args) do
        child_spec =     
            [
            %{
                id: room_name,
                start: {Room, :start_link, [args]},
                restart: :transient,
                type: :worker
            },
            %{
                id: to_string(room_name) <> "Stash",
                start: {Stash, :start_link, [args]},
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