defmodule PeriodicRoomBackup do
  use Task

  def start_link(room_name) do
    stash_name = to_string(room_name) <> "Stash"
    Task.start_link(PeriodicRoomBackup, :poll, [stash_name])
  end

  def poll(stash_name) do
    receive do
    after
      60_000 ->
        backup(stash_name)
        poll(stash_name)
    end
  end

  defp backup(stash_name) do
    GenServer.cast({:global, stash_name}, :backup)
  end
  
end