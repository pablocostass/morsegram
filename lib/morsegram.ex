defmodule Morsegram do
  @moduledoc """
  Documentation for Morsegram.
  """

  @doc """
  Function used to set everything up for the client.
  Also needed by OptionParser to work.

  ## Examples

      iex> Morsegram.hello()
      :world

  """
  def main(argv) do
    argv
    |> parse_args()
    |> set_parameters_up()
    |> prompt()
  end

  defp parse_args(args) do
    {parsed, _rest, _invalid} = 
      OptionParser.parse(args, strict: [user: :string, server: :string])
    [user: usr, server: srvr] = parsed
    {usr, srvr}
  end

  defp set_parameters_up({user, server}) do
    String.to_atom(user)
    |> Node.start()
    String.to_atom(server)
    |> Node.connect()
    IO.puts("Welcome to Morsegram!")
    user
  end

  defp prompt(username) do
    {:ok, [cmd, arg]} = :io.fread(Support.color_this("$ ", :cyan), '~ts ~ts')
    run(username, cmd, arg)
    prompt(username)
  end

  defp run(username, 'search_room', room) do
    Client.search_room(room, username)
  end
  defp run(username,'send_message', room) do
    msg = :io.get_line('#{username}: ')
    Client.send_message(msg, room, username)
  end
  defp run(username, 'list_users', room) do
    Client.list_users(room, username)
  end
  defp run(username, 'disconnect', room) do
    Client.disconnect_from(room, username)
  end
  defp run(username, '#', 'quit') do
    IO.puts "Disconnecting from Morsegram..."
    IO.puts "See you later, #{username}"
    :global.unregister_name(username)
    System.halt(0)
  end
  defp run(_, '#', 'help') do
    IO.puts "Commands:"
    IO.puts "search_room [room]"
    IO.puts "\t Finds a given room and connects you to it"
    IO.puts "send_message [room]"
    IO.puts "\t Gives you a prompt where you can type a message that will be sent to the given room"
    IO.puts "list_users [room]"
    IO.puts "\t Shows the list of users in a given room"
    IO.puts "disconnect [room]"
    IO.puts "\t Disconnects you from a given room"
    IO.puts "# help"
    IO.puts "\t Prints out this message"
    IO.puts "# quit"
    IO.puts "\t Closes Morsegram after printing you a goodbye message"
  end
  defp run(_, cmd, arg) do
    IO.puts "Unknown command '#{cmd} #{arg}', run the command '# help' to get the list of possible commands!"
  end
end
