note
	description: "Thread listening to the server"
	author: ""
	date: "28/10/13"
	revision: ""

class
	TR_CLIENT_LISTEN_THREAD

inherit
	THREAD

create
	make_with_mutex

feature --creator


	make_with_mutex(a_players_mutex, a_last_messages_chat_mutex, a_last_game_state_mutex : MUTEX)
	do
		make

		-- make client listening socket
		create socket.make_server_by_port (0)
		socket.listen (5)

		-- remembering client port
		client_listening_port := socket.port

		--setting our mutex(s)
		players_mutex := a_players_mutex
		last_messages_chat_mutex := a_last_messages_chat_mutex
		last_game_state_mutex := a_last_game_state_mutex
	end

feature --execute

	execute
	do
		from
			--initializing the variables in case it is not the first time we are running execute
			--setting our attributes to Void
			players := Void
			last_messages_chat := Void
			last_game_state := Void

			-- assuming that the listening thread is always starting at the beginning of the connection phase
			connection_phase := True
			has_game_started := False
		until
			--we stop executing this thread when we are neither in a game nor in a connection phase
			not (has_game_started or connection_phase)
		loop
			-- we wait for a connection			
			print("In TR_CLIENT_LISTEN_THREAD execute : Socket is listening " + socket.port.out + "%N")
			socket.accept
			-- when we have one :
			if attached socket.accepted as socket_client then
				print("In TR_CLIENT_LISTEN_THREAD execute : Socket accepted a connection with :" + socket_client.peer_address.host_address.host_address + ":" + socket_client.peer_address.port.out +"%N")
				if attached {TR_PACKET} socket_client.retrieved as cur_obj then
					print("In TR_CLIENT_LISTEN_THREAD execute : Received an object storable %N")
					if attached {TR_SERVER_PLAYER_ARRAY} cur_obj.data as cur_players then
						players_mutex.lock
						players := cur_players
						players_mutex.unlock
					elseif attached {TR_CHAT_LINE} cur_obj.data as cur_chat_line then
						last_messages_chat_mutex.lock
						if last_messages_chat = Void then
							create last_messages_chat.make
						end
						last_messages_chat.extend (cur_chat_line)
						last_messages_chat_mutex.unlock
					elseif attached {TR_GAME_STATE} cur_obj.data as cur_game_state then
						last_game_state_mutex.lock
						last_game_state := cur_game_state
						last_game_state_mutex.unlock
					elseif attached {TR_CLIENT_REQUEST} cur_obj.data as cur_client_request then
						if cur_client_request.request_type.is_equal ("START_GAME") then
							has_game_started := True
							connection_phase := False
						elseif cur_client_request.request_type.is_equal ("STOP_GAME") then
							has_game_started := False
						end
					end
				end
				socket_client.cleanup
			end
		end
	end



feature {TR_CLIENT} -- setting intern attributes to Void

	-- As these functions are called from the Client, we can't use mutex in these functions because this would cause a dead lock
	-- the client would lock the attributes and the listening thread would not allow modifying them until they are unlocked

	set_players_to_Void
	do
		players := Void
	end

	set_last_messages_chat_to_Void
	do
		last_messages_chat := Void
	end

	set_last_game_state_to_Void
	do
		last_game_state := Void
	end

feature {NONE}

	socket: NETWORK_STREAM_SOCKET
	client: TR_CLIENT

feature {TR_CLIENT}


	client_listening_port: INTEGER
		-- the port on which the thread will be listening

	players : TR_SERVER_PLAYER_ARRAY
		-- the players that joined

	players_mutex : MUTEX
		-- mutex to synchronize access to the array of players

	last_messages_chat : LINKED_LIST[TR_CHAT_LINE]
		-- the last messages received from the server (sent by the clients)

	last_messages_chat_mutex : MUTEX
		-- mutex to synchronize access to the last messages chat

	last_game_state : TR_GAME_STATE
		-- the last game state received from the server

	last_game_state_mutex : MUTEX
		-- mutex to synchronize access to the last game state

	has_game_started : BOOLEAN
		-- a boolean indicating if the game started or not

	connection_phase : BOOLEAN
		-- a boolean indicating if we are during the connection phase or not

end
