defmodule MainSupervisor do
  use DynamicSupervisor
  @moduledoc """
  Documentation for MainSupervisor.
  """

  @doc """
  Starts the main supervisor, whose job is to watch over 
  the room supervisors.
  """
  def start_link( _opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Initializes the supervisor.
  """
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a room supervisor to supervise.
  """
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