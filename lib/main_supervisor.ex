defmodule MainSupervisor do
    use DynamicSupervisor
  
    def start_link( _opts) do
      DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    end
  
    def init(_args) do
      DynamicSupervisor.init(strategy: :one_for_one)
    end
  
    def start_child({room_name, _user} = args) do
      child_spec =     
        %{
            id: room_name,
            start: {RoomSupervisor, :start_link, [args]},
            restart: :transient,
            type: :worker
        }
      DynamicSupervisor.start_child(MainSupervisor, child_spec)
    end
end