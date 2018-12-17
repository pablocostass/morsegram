<img src="./img/logo.png" height="100" />

# Morsegram
Morsegram is an Elixir based distributed chat application.
Our goal with this project was to learn and improve our knowledge about distributed architectures in Elixir/Erlang, besides acquiring experience with the Supervisor behaviour present in these languages.

> Note that in order to launch the program an escript build is used, so instead of starting an IEx session for the client, it is launched with `./morsegram` followed up of its parameters.

## Prerequisites
To be able to use `Morsegram` it is assumed that your computer has at least:

 - Elixir

## How to use it
The `Morsegram` module has an only entry point:

 - main/1 

This function receives as a parameter a list of arguments, parses them, and starts up the CLI. As it was noted earlier, although the function exists it is not needed to manually call it to get started:

    ./morsegram --user foo@XYZ_Node --server bar@ABC_Node

  > To be able to run the escript it is needed to beforehand build it with the following command:

    mix escript.build

  > Also it should be noted that the server should be up and running on a node for the client to work. To launch the server execute the following commands from the root project folder:

    iex --name bar@ABC_Node -S mix
    
    iex(bar@ABC_Node)1> Leader.start

Once done that, with the application launched you have the following commands for use:

  * search_room `room`
    * Finds a given room and connects you to it
  * send_message `room`
    * Gives you a prompt where you can type a message that will be sent to the given room
  * list_users `room`
    * Shows the list of users in a given room
  * disconnect `room`
    * Disconnects you from a given room
  * \# help
    * Prints out the commands available for use.
  * \# quit
    * Closes Morsegram after printing you a goodbye message

## Example
An example of the chat in use:

* A server up is started up and running in `foo@XYZ_Node`:
  ```sh
  iex --name foo@XYZ_Node -S mix
  ```
  ```Elixir
  iex(foo@XYZ_Node)1> Leader.start
  {:ok, #PID<0.179.0>}
  ```
* Any client can then start the CLI as follows:
  ```sh
  mix escript.build && ./morsegram --user bar@ABC_Node --server foo@XYZ_Node
  ```
  > For this example we will suppose that two clients, `bar@ABC_Node` and `bar2@DEF_Node`, are connected to the server.
* Which will print a greeting and start the prompt:
  ```Elixir
  Welcome to Morsegram!
  $
  ```
* After that the user is free to search for a room about any given topic:
  * Client `bar@ABC_Node`:
    ```Elixir
    $ search_room pinhas
    $ [18:52:39] [Connected to room pinhas]
    $ 
    ```
  * Client `bar2@DEF_Node`: 
    ```Elixir
    $ search_room pinhas
    $ [18:52:45] [Connected to room pinhas]
    $ 
    ```
  * This will notify client any other client on the room about the connection:
    ```Elixir
    $ [18:52:45] [Connected to room pinhas]
    $ [18:52:45] [User bar2@DEF_Node has connected to the room pinhas]
    ```
* And then send messages:
  * Client `bar@ABC_Node`:
    ```Elixir
    $ send_message pinhas
    bar@ABC_Node: cocos
    $ [18:53:03] [pinhas] bar@ABC_Node: cocos
    $ 
    ```
  * Which on client `bar2@DEF_Node` will be also printed out:
    ```Elixir
    $ [18:52:45] [Connected to room pinhas]
    $ [18:53:03] [pinhas] bar@ABC_Node: cocos
    $ 
    ```
* Any user can also see who they are chatting with on a given room by doing as follows:
  * Client `bar@ABC_Node`:
    ```Elixir
    $ list_users pinhas
    $ ["bar@ABC_Node", "bar2@DEF_Node"]
    $ 
    ```
* Users can disconnect from the room with the following command:
  * Client `bar@ABC_Node`:
    ```Elixir
    $ disconnect pinhas
    $ [18:53:15] [Disconnected from room pinhas]
    $ 
    ```
  * Which will notify any other client on the room about the disconnection:
    ```Elixir
    $ [18:53:03] [pinhas] bar@ABC_Node: cocos
    $ [18:53:15] [User bar@ABC_Node has disconnected from the room pinhas]
    $ 
    ```
* Users can print a list of commands available with the `# help` command:
  ```Elixir
  $ # help
  Commands:
  search_room [room]
    Finds a given room and connects you to it
  send_message [room]
    Gives you a prompt where you can type a message that will be sent to the given room
  list_users [room]
    Shows the list of users in a given room
  disconnect [room]
    Disconnects you from a given room
  # help
    Prints out this message
  # quit
    Closes Morsegram after printing you a goodbye message
  $ 
  ```
* Finally, users can quit the application with the use of the `# quit` command:
  ```Elixir
  $ [18:53:15] [Disconnected from room pinhas]
  $ # quit
  Disconnecting from Morsegram...
  See you later, bar@ABC_Node
  ```

## Credits
Done by:
Last name, first name  | Email
------------- | -------------
Ameneiros López, Bruno | bruno.ameneiros@udc.es
Costas Sánchez, Pablo | pablo.costas@udc.es
Garea Cidre, Javier | javier.garea@udc.es
Gómez García, Adrián | a.gomezg@udc.es
Piñeiro Ferrero, Ángel | angel.pineiro.ferrero@udc.es
Rivas Dorado, Héctor | hector.rivas@udc.es
