note
	description: "Object receiving or seding data from the server to controller and the opposite"
	author: "Justine Compagnon"
	date: "28/10/13"
	revision: ""

class
	TR_CLIENT

inherit
	ANY

create
	make_client,
	make_with_less_param

feature --creator

	make_client
	local
		player_default : TR_SERVER_PLAYER
	do
		server_address := Void
		server_port := 0


		-- creating the listening thread
		create players_mutex.make
		create last_messages_chat_mutex.make
		create last_game_state_mutex.make
		create listening_thread.make_with_mutex (players_mutex, last_messages_chat_mutex, last_game_state_mutex)

		-- remembering the client port
		client_port := listening_thread.client_listening_port

		-- launching the listening thread
		listening_thread.launch

	end

	make_with_less_param(current_controller:TR_CONTROLLER)
	obsolete
		"use make_client instead"
	local
		player_default : TR_SERVER_PLAYER
	do
--		controller := current_controller
		server_address := Void
		server_port := 0


		-- creating the listening thread
		create players_mutex.make
		create last_messages_chat_mutex.make
		create last_game_state_mutex.make
		create listening_thread.make_with_mutex (players_mutex, last_messages_chat_mutex, last_game_state_mutex)

		-- remembering the client port
		client_port := listening_thread.client_listening_port

		-- launching the listening thread
		listening_thread.launch

	end



feature --set

	-- set the adress of the server and the port in which the server is listening
	set_server_adress_and_port (current_server_adress:INET_ADDRESS ; current_server_port: INTEGER)
	do
		server_address := current_server_adress
		server_port := current_server_port
	end

feature --send

	-- take a request and send it to everyone
	send_to_everyone (obj: STORABLE) : STRING
	local
		packet: TR_PACKET
		dest : LINKED_LIST[STRING]
	do
		dest := get_all_names
		create packet.make (dest, obj)
		result := send_object_to_server(packet)
	end


	send_line_to_server(line: TR_CHAT_LINE ; private: BOOLEAN) : STRING
	local
		packet_to_send : TR_PACKET
		receivers : LINKED_LIST[STRING]
		answer : STRING
	do
		-- creating our socket to send
		create socket.make_client_by_address_and_port (server_address, server_port)

		-- making the receivers list depending on the private variable
		create receivers.make
		if private then
			receivers.extend (team_mate_name)
			receivers.extend (my_name)
		else
			receivers := get_all_names
		end

		--making our packet that we will want to send
		create packet_to_send.make (receivers, line)

		--sending everything
		socket.connect
		socket.independent_store (packet_to_send)
		if attached {TR_SERVER_ANSWER} socket.retrieved as answer_from_server then
			answer := answer_from_server.message
		end
		socket.cleanup

		result := answer
	ensure
		answer_has_been_made : result /= Void
	end


	send_object_to_server(packet_to_send: TR_PACKET): STRING
	local
		answer : STRING
	do
		-- creating our socket to send
		create socket.make_client_by_address_and_port (server_address, server_port)

		--sending everything
		socket.connect
		socket.independent_store (packet_to_send)
		if attached {TR_SERVER_ANSWER} socket.retrieved as answer_from_server then
			answer := answer_from_server.message
		end
		socket.cleanup

		result := answer
	ensure
		answer_has_been_made : result /= Void
	end

feature --join game


 	send_join_game_request_to_server(ip_server: INET_ADDRESS ;  port_server: INTEGER; name : STRING; team : INTEGER; ai : BOOLEAN) : STRING
 		-- Join a game with the ip (inet_adress) and the port
 	require
		team_exist : team >= 1 AND team <=2
 	local
 		packet : TR_PACKET
 		request : TR_CLIENT_REQUEST
 		join_player : TR_JOINING_PLAYER
 		dest : LINKED_LIST[STRING]
 	do
 		-- if the joining request is not for an AI, the name give is my_name
 		if not ai then
 			my_name := name
 			my_team := team
 		end

 		connection_phase := true
 		server_address := ip_server
 		server_port := port_server
		create join_player.make_ai (name, client_port, team, ai)
		create request.make ("JOIN_GAME", join_player)
		create dest.make
		create packet.make (dest, request)

		result := send_object_to_server(packet)
 	end

 	send_quit_connection_phase_request_to_server(name : STRING) : STRING
 	require
 		still_connection : connection_phase = true
 	local
 		packet : TR_PACKET
 		request : TR_CLIENT_REQUEST
 		changing_player : TR_CHANGING_PLAYER
 		dest : LINKED_LIST[STRING]
 		player : TR_CHANGING_PLAYER
 	do
 		create player.make_for_quit (name)
		create request.make ("QUIT_CONNECTION_PHASE", player)
		create dest.make
		create packet.make (dest, request)

		result := send_object_to_server(packet)
 	end

 	change_team(name : STRING;team : INTEGER) : STRING
 		-- Sending a request to change team to the server
 	require
 		still_connection : connection_phase = true
		team_exist : team >= 1 AND team <=2
	local
 		packet : TR_PACKET
 		request : TR_CLIENT_REQUEST
 		changing_player : TR_CHANGING_PLAYER
 		dest : LINKED_LIST[STRING]
 	do
 		if name.is_equal (my_name) then
 			my_team := team
 		end
		create changing_player.make (name, team)
		create request.make ("CHANGE_TEAM", changing_player)
		create dest.make
		create packet.make (dest, request)

		result := send_object_to_server(packet)
	end

 	send_change_ready_state_request_to_server(name : STRING;ready_state : BOOLEAN) : STRING
 		-- Sending a request to change team to the server
 	require
 		still_connection : connection_phase = true
	local
 		packet : TR_PACKET
 		request : TR_CLIENT_REQUEST
 		changing_player : TR_CHANGING_PLAYER
 		dest : LINKED_LIST[STRING]
 	do
		create changing_player.make_for_ready_state_change (name, ready_state)
		create request.make ("CHANGE_READY_STATE", changing_player)
		create dest.make
		create packet.make (dest, request)

		result := send_object_to_server(packet)
	end



 	send_start_game_request_to_server : STRING
 		-- Sending a request to start the game to the server
 	require
 		still_connection : connection_phase = true
	local
 		packet : TR_PACKET
 		request : TR_CLIENT_REQUEST
 		dest : LINKED_LIST[STRING]
 		answer_from_server : STRING
 	do
		create request.make ("START_GAME", Void)
		create dest.make
		create packet.make (dest, request)
		answer_from_server := send_object_to_server(packet)
		if answer_from_server.is_equal ("OK_START_GAME") then
			connection_phase := false
		end
		result := answer_from_server
	end

	send_stop_game_request_to_server : STRING
	require
		is_a_connection : is_there_a_game_running = true
	local
		packet : TR_PACKET
 		request : TR_CLIENT_REQUEST
 		dest : LINKED_LIST[STRING]
 		answer_from_server : STRING
	do
		create request.make ("STOP_GAME", Void)
		create dest.make
		create packet.make (dest, request)
		answer_from_server := send_object_to_server(packet)
		result := answer_from_server
	end


feature -- retrieve data from the listening thread

	get_last_array_of_players : TR_SERVER_PLAYER_ARRAY
		-- retrieve the last array of players received by the listening thread from the server
	local
		last_array : TR_SERVER_PLAYER_ARRAY
	do
		-- asking to get the players array
		players_mutex.lock

		-- once we have it we read it
		last_array := listening_thread.players
		-- if it is not emty we save it and put it back to Void
		if last_array /= Void then
			players := last_array
			listening_thread.set_players_to_void
		end

		-- finally we release it
		players_mutex.unlock


		result := last_array
	end

	get_last_game_state : TR_GAME_STATE
		-- retrieve the last game_state received by the listening thread from the server
	local
		last_game_state : TR_GAME_STATE
	do
		-- asking to get the game state
		last_game_state_mutex.lock

		-- once we have it we read it
		last_game_state := listening_thread.last_game_state
		-- if it is not emty we put it to Void
		if last_game_state /= Void then
			listening_thread.set_last_game_state_to_void
		end

		-- finally we release it
		last_game_state_mutex.unlock


		result := last_game_state
	end

	get_last_messages : LINKED_LIST[TR_CHAT_LINE]
		-- retrieve the last messages received by the listening thread from the server
	local
		last_msgs : LINKED_LIST[TR_CHAT_LINE]
	do
		-- asking to get the last messages
		last_messages_chat_mutex.lock

		-- once we have them we read them
		last_msgs := listening_thread.last_messages_chat
		-- if there is at least one message we set it to Void
		if last_msgs /= Void then
			listening_thread.set_last_messages_chat_to_void
		end

		-- finally we release them
		last_messages_chat_mutex.unlock


		result := last_msgs
	end

	has_game_started : BOOLEAN
		-- retrieve the boolean indicating if the game_started from the listening thread which received it from the server
	local
		game_started : BOOLEAN
	do
		game_started := listening_thread.has_game_started

		result := game_started
	end

	is_there_a_game_running : BOOLEAN
		-- return true if the listening thread is not in the connection phase and has its game_started boolean set to false
	local
		game_stopped : BOOLEAN
	do
		game_stopped  := not (listening_thread.connection_phase or listening_thread.has_game_started)

		result := not game_stopped
	end

feature {NONE,TR_TEST_CLIENT}

	team_mate_name : STRING
	local
		his_name : STRING
		i : INTEGER
		player_found : BOOLEAN
	do
		from
			i := players.lower
			player_found := False
		until
			i > players.upper or player_found
		loop
			if (not players.at (i).name.is_equal (my_name) and players.at (i).team = my_team) then
				player_found := True
				his_name := players.at (i).name
			end
			i := i + 1
		end
		result := his_name
	end

	get_all_names : LINKED_LIST[STRING]  -- gice all the names of the four clients
	local
		list_player : LINKED_LIST[STRING]
		i : INTEGER
	do
		from
			i := players.lower
			create list_player.make
		until
			i > players.upper
		loop
			list_player.extend (players.at (i).name)
			i := i + 1
		end
		result := list_player
	end



feature {NONE,TR_TEST_CLIENT}  -- attribute

--	controller : TR_CONTROLLER
	socket : NETWORK_STREAM_SOCKET
	listening_thread : TR_CLIENT_LISTEN_THREAD

feature {ANY}  -- attribut public
--	chat : LINKED_LIST[TR_CHAT_LINE]
		-- the chat object that will contain all the chatlines
	players : TR_SERVER_PLAYER_ARRAY
		-- the players that joined
	my_team : INTEGER
		-- the client team number
	my_name : STRING
		-- the client name
	connection_phase : BOOLEAN
		-- a boolean indicating if we are during connection phase or not
	server_address : INET_ADDRESS
		-- the server address
	server_port : INTEGER
		-- the server listening port
	client_port : INTEGER
		-- on which port the client thread is listening

feature {ANY} -- mutex for synchronizing the client with the listening thread

	players_mutex : MUTEX
		-- mutex to synchronize access to the array of players

	last_messages_chat_mutex : MUTEX
		-- mutex to synchronize access to the last messages chat

	last_game_state_mutex : MUTEX
		-- mutex to synchronize access to the last game state

end

