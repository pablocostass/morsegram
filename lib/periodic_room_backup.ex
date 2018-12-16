defmodule PeriodicRoomBackup do
  use Task
  @moduledoc """
  Documentation for PeriodicRoomBackup.
  """

  @doc """
  Starts a task to periodically back up the room state.
  """
  def start_link(room_name) do
    stash_name = to_string(room_name) <> "Stash"
    Task.start_link(PeriodicRoomBackup, :poll, [stash_name])
  end

  @doc """
  Every three seconds a backup is asked for.
  """
  def poll(stash_name) do
    receive do
    after
      3_000 ->
        backup(stash_name)
        poll(stash_name)
    end
  end

  defp backup(stash_name) do
    GenServer.cast({:global, stash_name}, :backup)
  end
  
end