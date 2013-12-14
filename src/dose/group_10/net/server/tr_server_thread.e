note
	description: "Server able to connect four persons that want to play truco together"
	author: "Gabriel Mabille"
	date: "28/10/2010"
	revision: ""

class
	TR_SERVER_THREAD

inherit
	THREAD

create
	make_server_on_free_port,
	make_server,
	make_server_with_controller

feature {ANY} -- creator

	make_server_on_free_port
		-- make the TR_SERVER_THREAD listening on a free port	
	local
		player_default : TR_SERVER_PLAYER
	do
		make
		--make server socket listening on a free port
		create listen_socket.make_server_by_port (0)
		--making array of players
		create player_default.make_complete ("SERVEUR_UNKNOWN",1, Void,1,False)
		create players.make_filled (player_default,0, 3)
		--saving that we still have no players for the moment
		nbr_players := 0
	end

	make_server(port : INTEGER)
		-- make the TR_SERVER_THREAD listening on the port given
	obsolete
		"use make_server_with_controller instead"
	local
		player_default : TR_SERVER_PLAYER
	do
		make
		--make server socket listening on a free port
		create listen_socket.make_server_by_port (port)
		--making array of players
		create player_default.make_complete ("SERVEUR_UNKNOWN",1, Void,1,False)
		create players.make_filled (player_default,0, 3)
		--saving that we still have no players for the moment
		nbr_players := 0
	end

	make_server_with_controller(game_controller : TR_CONTROLLER)
		-- make the TR_SERVER_THREAD listening on a free port
		-- and update the controller on this port thanks to the reference given in parameter
	local
		player_default : TR_SERVER_PLAYER
	do
		make
		--make server socket listening on a free port
		create listen_socket.make_server_by_port (0)
		--making array of players
		create player_default.make_complete ("SERVEUR_UNKNOWN",1, Void,1,False)
		create players.make_filled (player_default,0, 3)
		--saving that we still have no players for the moment
		nbr_players := 0
		--update the controller on the port given by the system
		controller := game_controller
		controller.set_server_port(get_listening_port)
	end

feature {ANY} -- inherited to implement

	execute
	do
		print("In TR_SERVER_THREAD execute : Entered execution %N")
		--make server socket listening up to ten connections
		listen_socket.listen (10)
		--tell the controller ip and port
		print("IP -> " + get_address.out + ":" + get_listening_port.out + "%N")
		-- controller.print_server_ip (get_address)
		-- controller.print_server_port (get_listening_port)
		--first we let the players connect themselves and make their teams
		connection_process
		--then we let the players play
		game_process
		--finally we close the connection
		listen_socket.close
		print("In TR_SERVER_THREAD execute : Entered execution %N")
	end

feature {NONE,TR_TEST_NETWORK} -- connection exchanges

	connection_process
		-- process running during the connection phase
	local
		answer : TR_SERVER_ANSWER
		answer_string: STRING
		client_request: TR_CLIENT_REQUEST
	do
		from
			game_started := false
		until
			game_started
		loop
			print("In TR_SERVER_THREAD connection_process : Socket is listening " + listen_socket.port.out + "%N")
			listen_socket.accept
			if attached listen_socket.accepted as socket_client then
				print("In TR_SERVER_THREAD connection_process : Socket accepted a connection %N")
				-- we have a client
				if attached {TR_PACKET} socket_client.retrieved as packet_received then
					print("In TR_SERVER_THREAD connection_process : Socket retrieved a packet %N")
					-- if there is no destination it is for the server
					if packet_received.receivers.is_empty then
						print("In TR_SERVER_THREAD connection_process : My god! Empty list!%N")
						answer_string := treat_connection_packet(packet_received,socket_client.peer_address.host_address)
						create answer.make (answer_string)
					else
						print("In TR_SERVER_THREAD connection_process : My god! Not Empty list! REJECT %N")
						create answer.make ("REJECT_CONNECTION_PHASE")
					end
				else
					print("In TR_SERVER_THREAD connection_process : received something but not a TR_PACKET %N")
					create answer.make ("REJECT_NOT_A_TR_PACKET")
				end
				print("In TR_SERVER_THREAD connection_process : Answer from server : " + answer.message + "%N")
				--sending the server answer to the client
				socket_client.independent_store (answer)
				socket_client.cleanup
				-- if the server answer is one of the following we send the players to everyone
				if  answer_string.is_equal ("PLAYER_ADDED") or  answer_string.is_equal ("PLAYER_TEAM_CHANGED") or  answer_string.is_equal ("PLAYER_READY_STATE_CHANGED") or answer_string.is_equal ("OK_QUIT_CONNECTION_PHASE") then
					send_to_every_client(players)
				-- if the answe is start game then we send to everyone that we are starting the game
				elseif answer_string.is_equal ("OK_START_GAME") then
					create client_request.make ("START_GAME", void)
					send_to_every_client(client_request)
					game_started := true
				end

				--closing and unlinking

			end
		end

	end

	treat_connection_packet(connection_packet : TR_PACKET; player_address : INET_ADDRESS) : STRING
		-- treat a connection packet and return the answer from the server
	local
		answer : STRING
	do
		-- if it is a connection request then we must know what kind of request it is
		if attached {TR_CLIENT_REQUEST} connection_packet.data as connection_request then

			-- if it is a join request
			if connection_request.request_type.is_equal ("JOIN_GAME") then
				if attached {TR_JOINING_PLAYER} connection_request.obj as new_player then
					answer := treat_joining_request(new_player,player_address)
--					if answer.is_equal ("PLAYER_ADDED") then
--						send_to_every_client(connection_packet)
--					end
				end
			elseif connection_request.request_type.is_equal ("CHANGE_TEAM") then
				if attached {TR_CHANGING_PLAYER} connection_request.obj as changing_player then
					answer := treat_changing_team_request(changing_player)
--					if answer.is_equal ("PLAYER_TEAM_CHANGED") then
--						send_to_every_client(connection_packet)
--					end
				end
			elseif connection_request.request_type.is_equal ("CHANGE_READY_STATE") then
				if attached {TR_CHANGING_PLAYER} connection_request.obj as changing_player then
					answer := treat_changing_ready_state_request(changing_player)
--					if answer.is_equal ("PLAYER_READY_STATE_CHANGED") then
--						send_to_every_client(connection_packet)
--					end
				end
			elseif  connection_request.request_type.is_equal ("QUIT_CONNECTION_PHASE") then
				if attached {TR_CHANGING_PLAYER} connection_request.obj as changing_player then
					answer:= treat_quit_connection_phase_request(changing_player.name)
				end

			elseif connection_request.request_type.is_equal ("START_GAME") then
				answer := treat_start_game_request
--				if answer.is_equal ("OK_START_GAME") then
--					send_to_every_client(connection_packet)
--					game_started := True
--				end
			else
				answer:="REJECT_UNKNOWN_REQUEST"
			end
		end
		result := answer
	ensure
		answer_has_been_made : result /= Void
	end

	treat_joining_request(new_player : TR_JOINING_PLAYER; new_player_address : INET_ADDRESS) : STRING
		-- treat a request to join and return an answer to this request
	local
		worked_well : BOOLEAN
		player_to_add : TR_SERVER_PLAYER
		i : INTEGER
		answer : STRING
	do
		worked_well := true
		--checking that there isn't already 4 players
		if nbr_players>=4 then
			worked_well := false
			answer := "ALREADY_FOUR_PLAYERS"
		--checking if the new player's name is not already taken
		elseif (get_player_position_in_array(new_player.name)/=-1) then
			worked_well := false
			answer := "PLAYER_NAME_ALREADY_USED"
		end
		--if everything went fine the we can add him
		if worked_well then
			create player_to_add.make_complete (new_player.name, new_player.team, new_player_address, new_player.client_port, new_player.is_ai)
			players[nbr_players] := player_to_add
			nbr_players := nbr_players + 1
			answer := "PLAYER_ADDED"
		end
		result := answer
	ensure
		answer_has_been_made : result /= Void
		modification_have_been_made_when_needed : (result.is_equal ("PLAYER_ADDED") and nbr_players > 0 and players[nbr_players-1].name.is_equal (new_player.name) and players[nbr_players-1].team = new_player.team and players[nbr_players-1].port = new_player.client_port and players[nbr_players-1].ip = new_player_address) or not result.is_equal ("PLAYER_ADDED")
	end

	treat_changing_team_request(changing_player : TR_CHANGING_PLAYER) : STRING
		-- treat a request to change player's team and return an answer to this request
	local
		i : INTEGER
		answer : STRING
	do
		--searching for the player in our array of player
		i := get_player_position_in_array(changing_player.name)
		--checking if the new player's name is not already taken
		if (i = -1) then
			answer := "PLAYER_IS_NOT_PRESENT"
		else
				players.at (i).set_team (changing_player.new_team)
				answer := "PLAYER_TEAM_CHANGED"
		end
		result := answer
	ensure
		answer_has_been_made : result /= Void
		modification_have_been_made_when_needed : (result.is_equal ("PLAYER_TEAM_CHANGED") and players[get_player_position_in_array(changing_player.name)].team = changing_player.new_team) or not result.is_equal ("PLAYER_TEAM_CHANGED")
	end


	treat_changing_ready_state_request(changing_player : TR_CHANGING_PLAYER) : STRING
		-- treat a request to change player's team and return an answer to this request
	local
		i : INTEGER
		answer : STRING
	do
		--searching for the player in our array of player
		i := get_player_position_in_array(changing_player.name)
		--checking if the new player's name is not already taken
		if (i = -1) then
			answer := "PLAYER_IS_NOT_PRESENT"
		else
				players.at (i).change_ready_state (changing_player.new_ready_state)
				answer := "PLAYER_READY_STATE_CHANGED"
		end
		result := answer
	ensure
		answer_has_been_made : result /= Void
		modification_have_been_made_when_needed : (result.is_equal ("PLAYER_TEAM_CHANGED") and players[get_player_position_in_array(changing_player.name)].team = changing_player.new_team) or not result.is_equal ("PLAYER_TEAM_CHANGED")
	end


	treat_quit_connection_phase_request (player_name : STRING) : STRING
		-- to remove the player from the list of player and answer to the request
		local
			i : INTEGER
			answer : STRING
			player_default : TR_SERVER_PLAYER
		do
			i:= get_player_position_in_array(player_name)
			if i = -1  then
				answer := "PLAYER_IS_NOT_PRESENT"
			else
				create player_default.make_complete ("SERVER_UNKNOWN", 1, Void, 1, False)
				players.at (i) := players.at (nbr_players - 1)
				players.at (nbr_players - 1) := player_default
				nbr_players := nbr_players - 1
				answer :=  "OK_QUIT_CONNECTION_PHASE"
			end

			result := answer
		ensure
			answer_has_been_made : result /= Void
		end


	treat_start_game_request : STRING
		-- treat a request to start the game and return an answer to this request
	local
		answer : STRING
	do
		if (nbr_players /= 4) then
			answer := "REJECT_NOT_ENOUGH_PLAYERS"
		elseif not teams_made then
			answer := "REJECT_TEAMS_NOT_MADE"
		elseif not players_are_ready_to_start_a_game then
			answer := "REJECT_PLAYERS_ARE_NOT_READY"
		else
			answer := "OK_START_GAME"
		end
		result := answer
	ensure
		answer_has_been_made : result /= Void
	end

feature {NONE,TR_TEST_NETWORK} -- game exchanges

	game_process
		-- process running during the game phase
	local
		answer : TR_SERVER_ANSWER
		packet : TR_PACKET
	do
		from
			game_stopped := False
			packet := Void
		until
			game_stopped
		loop
			print("In TR_SERVER_THREAD game_process : Socket is listening " + listen_socket.port.out + "%N")
			listen_socket.accept
			if attached listen_socket.accepted as socket_client then
				print("In TR_SERVER_THREAD game_process : Socket accepted a connection %N")
				-- we have a client
				if attached {TR_PACKET} socket_client.retrieved as packet_received then
					print("In TR_SERVER_THREAD game_process : received a TR_PACKET %N")
					-- if there is destinations it is for the game
					if not packet_received.receivers.is_empty then
						print("In TR_SERVER_THREAD game_process : received and it has no destination empty %N")
						create answer.make (answer_for_routing_request(packet_received))
						packet := packet_received
					-- if there is no destinations it is for the server and must be a client request
					else
						if attached {TR_CLIENT_REQUEST} packet_received.data as request then
							-- in case it is a request to stop the game
							-- we change the answer to OK_STOPPING_THE_GAME
							if request.request_type.is_equal ("STOP_GAME") then
								create answer.make ("OK_STOPPING_THE_GAME")
								game_stopped := True
								packet := packet_received
							end
						else
							create answer.make ("REJECT_GAME_PHASE")
						end
					end
				else
					print("In TR_SERVER_THREAD game_process : received something but not a TR_PACKET %N")
					create answer.make ("REJECT_NOT_A_TR_PACKET")
				end
				print("In TR_SERVER_THREAD game_process : Answer from server : " + answer.message + "%N")
				--sending the server answer to the client
				socket_client.independent_store (answer)
				--closing and unlinking
				socket_client.cleanup
				-- we route the packet properly
				if answer.message.is_equal ("OK_PACKET_IS_GOING_TO_BE_ROUTED") then
					route_game_packet(packet)
				elseif answer.message.is_equal ("OK_STOPPING_THE_GAME") then
					send_to_every_client (packet.data)
				end
			end
		end
	end

	answer_for_routing_request(packet : TR_PACKET) : STRING
	-- return an answer from the server to tell if the packet is routable or not
	local
		answer : STRING
		i : INTEGER
		indexes : ARRAY[INTEGER] -- player's indexes in the player array
	do
		-- we prepare an array that will contain the receivers index in the array of player
		create indexes.make_filled (-1, 0, packet.receivers.count-1)
		-- we assume everything is going to work
		answer := "OK_PACKET_IS_GOING_TO_BE_ROUTED"

		--first we check if every player's name on the receivers list is a player from the game
		from
			packet.receivers.start
			i := 0
		until
			packet.receivers.exhausted
		loop
			indexes[i] := get_player_position_in_array(packet.receivers.item)
			if (indexes[i] = -1) then
				answer := "REJECT_PLAYER_NOT_FOUND"
			end
			-- going to the next composant
			i := i + 1
			packet.receivers.forth
		end

		result := answer

	ensure
		answer_has_been_made : result /= Void
	end



	route_game_packet (packet : TR_PACKET)
		-- forward the packet to its destination list and return an answer from the server
	local
		packetToSend : TR_PACKET
		receivers : LINKED_LIST[STRING]
		answer : STRING
		index : INTEGER  -- player index
	do

		answer := answer_for_routing_request(packet)
--		 if every player is from the game then we can send the message
		if (not answer.is_equal ("REJECT_PLAYER_NOT_FOUND")) then
			-- we make an empty receivers list
			create receivers.make
			-- we make a packet with the data, this packet will be sent to everyone on the list
			create packetToSend.make (receivers, packet.data)
			-- now we send the packet to everyone
			from
				packet.receivers.start
			until
				packet.receivers.exhausted
			loop
				index := get_player_position_in_array(packet.receivers.item)
				--if the player is not an AI we can send him the packet
				if not players.at (index).is_ai then
					print("In TR_SERVER_THREAD route_game_packet : Sending answer to client : " + players.at (index).name + "%N")
					--creating the socket to forward the data to the player concerned
					create send_socket.make_client_by_address_and_port (players.at (index).ip,players.at (index).port)
					print("In TR_SERVER_THREAD route_game_packet : Connecting socket %N")
					--connecting the server's socket to send
					send_socket.connect
					print("In TR_SERVER_THREAD route_game_packet : Sending packet %N")
					--routing the packet
					send_socket.independent_store (packetToSend)
					print("In TR_SERVER_THREAD route_game_packet : Closing connection %N")
					--closing and unlinking
					send_socket.cleanup
					print("In TR_SERVER_THREAD route_game_packet : Connection closed %N")
				end

				--incrementing the index
				packet.receivers.forth
			end
		end

--	rescue
--		if (send_socket /= Void) then
--			answer := "PLAYER_"+players.at (i).name+"_DISCONNECTED"
--			send_socket.cleanup
--		end
	end

feature {NONE,TR_TEST_NETWORK} --send

	send_to_every_client(data : STORABLE)
	local
		receivers : LINKED_LIST[STRING]
		packet_to_send : TR_PACKET
		i : INTEGER
	do
		create receivers.make
		create packet_to_send.make (receivers, data)
		-- now we send the packet to everyone
		from
			i := 0
		until
			i > nbr_players - 1
		loop
			--if the player is not an AI we can send him the packet
			if not players.at (i).is_ai then
				print("In TR_SERVER_THREAD send_to_every_client : Sending object to client : " + players.at (i).name + "->" + players.at (i).ip.host_address + ":" + players.at (i).port.out + "%N")
				--creating the socket to send the data to the player concerned
				create send_socket.make_client_by_address_and_port (players.at (i).ip,players.at (i).port)
				print("In TR_SERVER_THREAD send_to_every_client : Connecting socket %N")
				--connecting the server's socket to send
				send_socket.connect
				print("In TR_SERVER_THREAD send_to_every_client : Sending packet %N")
				--sending the packet
				send_socket.independent_store (packet_to_send)
				print("In TR_SERVER_THREAD send_to_every_client : Closing connection...")
				--closing and unlinking
				send_socket.cleanup
				print(" Closed %N")
			end
			--incrementing the index
			i := i + 1
		end
	end

feature {ANY} -- access

	set_controller(game_controller : TR_CONTROLLER)
		-- Setting the controller.
		-- /!\ Has to be done before launching
	do
		controller := game_controller
	end

feature {NONE,TR_TEST_NETWORK} -- access to players settings

	get_player_position_in_array(name : STRING) : INTEGER
		-- returns the player's position in the array of player (-1 if not in the array)
	local
		position : INTEGER
		i : INTEGER
	do
		from
			position := -1
			i := players.lower
		until
			i > nbr_players-1 or position /= -1
		loop
			if (players.at (i).name.is_equal (name)) then
				position := i
			end
			i := i + 1
		end
		result := position
	end

feature {ANY} -- informations

	get_listening_port : INTEGER
		-- returns the port in which the server is listening
	do
		result := listen_socket.port;
	end

	get_address : STRING
		-- returns the server's address
	local
		ad : INET_ADDRESS_FACTORY
	do
		create ad
		result := ad.create_localhost.host_address
	end

	get_inet_address : INET_ADDRESS
		-- returns the server's address as INET_ADDRESS
	local
		ad : INET_ADDRESS_FACTORY
	do
		create ad
		result := ad.create_localhost
	end


feature -- control

	teams_made : BOOLEAN
		-- allows this class to know if the team are made
	local
		nbr_team1 : INTEGER
		nbr_team2 : INTEGER
		i : INTEGER
		teams_are_made : BOOLEAN
	do
		from
			i := players.lower
			nbr_team1 := 0
			nbr_team2 := 0
			teams_are_made := False
		until
			i > players.upper
		loop
			if (players[i].team = 1) then
				nbr_team1 := nbr_team1 + 1
			elseif (players[i].team = 2) then
				nbr_team2 := nbr_team2 + 1
			end
			i := i + 1
		end
		if (nbr_team1 = 2 and nbr_team2 = 2) then
			teams_are_made := True
		end
		result := teams_are_made
	end


	players_are_ready_to_start_a_game : BOOLEAN
	local
		i : INTEGER
		players_are_ready : BOOLEAN
	do
		from
			i := players.lower
			players_are_ready := True
		until
			i > players.upper
		loop
			if not (players[i].is_ready) then
				players_are_ready := false
			end
			i := i + 1
		end
		result := players_are_ready
	end

feature {NONE,TR_TEST_NETWORK} -- attributs

	listen_socket : NETWORK_STREAM_SOCKET;
		-- socket in which clients are connecting

	send_socket : NETWORK_STREAM_SOCKET;
		-- socket to send data to the clients

	players : TR_SERVER_PLAYER_ARRAY;
		-- array containing the players	

	nbr_players : INTEGER
		-- the number of player who joined

	controller : TR_CONTROLLER
		-- to update the controller at the beginning

	game_started : BOOLEAN
		-- allows user to know if the game stated

	game_stopped : BOOLEAN
		-- allows user to know if the game stopped
end
