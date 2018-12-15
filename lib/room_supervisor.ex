defmodule RoomSupervisor do
    use Supervisor
    
    def start_link({room_name, _user} = args) do
        Supervisor.start_link(__MODULE__, args, name: __MODULE__)
    end

    def init({room_name, _user} = args) do
        child_spec =     
            [%{
                id: room_name,
                start: {Room, :start_link, [args]},
                # :brutal_kill, :infinity
                #shutdown: 5_000,
                # :temporary, :transient, :permanent
                restart: :transient,
                type: :worker
            }]
        Supervisor.init(child_spec, [strategy: :one_for_one, name: {:global, room_name}])
    end
end