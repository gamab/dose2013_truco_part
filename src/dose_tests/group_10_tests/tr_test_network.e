note
	description: "TR_TEST_NETWORK Tests the net part of the TR net (client and server)"
	author: ""
	date: ""
	revision: ""

class
	TR_TEST_NETWORK

inherit
	EQA_TEST_SET

feature -- test for TR_SERVER_THREAD make

	test_server_make_server_with_controller
	local
		server : TR_SERVER_THREAD
		worked_well : BOOLEAN
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		worked_well := server.listen_socket.port > 0
		print("worked_well for the socket: " + worked_well.out + "%N")
		worked_well := worked_well and server.players.count = 4
		print("worked_well for the creation of the players : " + worked_well.out + "%N")
		worked_well := worked_well and server.nbr_players = 0
		print("worked_well for the initialization of the nbr of players : " + worked_well.out + "%N")
		worked_well := worked_well
		print("worked_well for setting the reference to the controller : " + worked_well.out + "%N")
		assert("test_make_server_with_controller", worked_well)
	end

feature -- test for TR_SERVER_THREAD treat_joining_request

	test_treat_joining_request_1
	local
		server : TR_SERVER_THREAD
		new_player : TR_JOINING_PLAYER
		new_player_address : INET_ADDRESS
		ad : INET_ADDRESS_FACTORY
		answer : STRING
		worked_well : BOOLEAN
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create new_player.make ("Test",23456,1)
		create ad.default_create
		new_player_address :=  ad.create_localhost
		answer := server.treat_joining_request(new_player,new_player_address)
		worked_well := answer.is_equal ("PLAYER_ADDED")
		print("answer = PLAYER_ADDED : " + worked_well.out + "%N")
		worked_well := worked_well and server.nbr_players = 1
		print("nb_players = 1 : " + worked_well.out + "%N");
		worked_well := worked_well and server.players.at (0).ip = new_player_address
		worked_well := worked_well and server.players.at (0).name.is_equal ("Test")
		worked_well := worked_well and server.players.at (0).port = 23456
		worked_well := worked_well and server.players.at (0).team = 1
		print("players[0] = new_player : " + worked_well.out + "%N");
		assert("test_treat_joining_request_1", worked_well)
	end

	test_treat_joining_request_2
	local
		server : TR_SERVER_THREAD
		new_player : TR_JOINING_PLAYER
		players : ARRAY[TR_JOINING_PLAYER]
		new_player_address : INET_ADDRESS
		ad : INET_ADDRESS_FACTORY
		answer : STRING
		worked_well : BOOLEAN
		i : INTEGER
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create ad.default_create
		new_player_address :=  ad.create_localhost
		create players.make_empty
		players.grow (5)
		create new_player.make ("Test0",23456,1)
		players.at (1) := new_player
		create new_player.make ("Test1",23457,1)
		players.at (2) := new_player
		create new_player.make ("Test2",23458,2)
		players.at (3) := new_player
		create new_player.make ("Test3",23459,2)
		players.at (4) := new_player
		create new_player.make ("Test4",23460,2)
		players.at (5) := new_player


		from
			i := players.lower
		until
			i > players.upper
		loop
			print(i.out + "th player : " + players.at (i).name + "%N")
			i := i + 1
		end


		from
			i := players.lower
		until
			i > players.upper
		loop
			answer := server.treat_joining_request(players.at (i),new_player_address)
			print(i.out + "th answer : " + answer + "%N")
			i := i + 1
		end

		worked_well := answer.is_equal ("ALREADY_FOUR_PLAYERS")
		worked_well := worked_well and server.nbr_players = 4
		worked_well := worked_well and server.players.count = 4
		assert("test_treat_joining_request_2", worked_well)
	end

	test_treat_joining_request_3
	local
		server : TR_SERVER_THREAD
		new_player : TR_JOINING_PLAYER
		new_player2 : TR_JOINING_PLAYER
		new_player_address : INET_ADDRESS
		ad : INET_ADDRESS_FACTORY
		answer : STRING
		worked_well : BOOLEAN
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create new_player.make ("Test",23456,1)
		create new_player2.make ("Test",23457,2)
		create ad.default_create
		new_player_address :=  ad.create_localhost
		answer := server.treat_joining_request(new_player,new_player_address)
		print("First answer : " + answer + "%N")
		answer := server.treat_joining_request(new_player2,new_player_address)
		print("Second answer : " + answer + "%N")
		worked_well := answer.is_equal ("PLAYER_NAME_ALREADY_USED")
		assert("test_treat_joining_request_3", worked_well)
	end



feature -- test for TR_SERVER_THREAD treat_changing_team_request

	test_treat_changing_team_request_1
	local
		server : TR_SERVER_THREAD
		new_player : TR_JOINING_PLAYER
		changing_player : TR_CHANGING_PLAYER
		new_player_address : INET_ADDRESS
		ad : INET_ADDRESS_FACTORY
		answer : STRING
		worked_well : BOOLEAN
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create new_player.make ("Test",23456,1)
		create changing_player.make ("Test", 2)
		create ad.default_create
		new_player_address :=  ad.create_localhost
		answer := server.treat_joining_request(new_player,new_player_address)
		print("First answer : " + answer + "%N")
		answer := server.treat_changing_team_request(changing_player)
		print("Second answer : " + answer + "%N")
		worked_well := answer.is_equal ("PLAYER_TEAM_CHANGED")
		worked_well := worked_well and server.players.at (0).team = 2
		print("player[0].team = 2 : " + worked_well.out + "%N")
		assert("test_treat_changing_team_request_1", worked_well)
	end

	test_treat_changing_team_request_2
	local
		server : TR_SERVER_THREAD
		new_player : TR_JOINING_PLAYER
		changing_player : TR_CHANGING_PLAYER
		new_player_address : INET_ADDRESS
		ad : INET_ADDRESS_FACTORY
		answer : STRING
		worked_well : BOOLEAN
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create new_player.make ("Test",23456,1)
		create changing_player.make ("Test2", 2)
		create ad.default_create
		new_player_address :=  ad.create_localhost
		answer := server.treat_joining_request(new_player,new_player_address)
		print("First answer : " + answer + "%N")
		answer := server.treat_changing_team_request(changing_player)
		print("Second answer : " + answer + "%N")
		worked_well := answer.is_equal ("PLAYER_IS_NOT_PRESENT")
		worked_well := worked_well and server.players.at (0).team = 1
		print("player[0].team = 1 : " + worked_well.out + "%N")
		assert("test_treat_changing_team_request_2", worked_well)
	end

feature -- test for TR_SERVER_THREAD treat_start_game_request

	test_treat_start_game_request_1
	local
		server : TR_SERVER_THREAD
		new_player : TR_JOINING_PLAYER
		new_player_address : INET_ADDRESS
		ad : INET_ADDRESS_FACTORY
		answer : STRING
		worked_well : BOOLEAN
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create new_player.make ("Test",23456,1)
		create ad.default_create
		new_player_address :=  ad.create_localhost
		answer := server.treat_joining_request(new_player,new_player_address)
		print("First answer (to join) : " + answer + "%N")
		answer := server.treat_start_game_request
		print("Second answer (to start game) : " + answer + "%N")
		worked_well := answer.is_equal ("REJECT_NOT_ENOUGH_PLAYERS")
		print("answer = REJECT_NOT_ENOUGH_PLAYERS : " + worked_well.out + "%N")
		assert("test_treat_start_game_request_1", worked_well)
	end

	test_treat_start_game_request_2
	local
		server : TR_SERVER_THREAD
		new_player1 : TR_JOINING_PLAYER
		new_player2 : TR_JOINING_PLAYER
		new_player3 : TR_JOINING_PLAYER
		new_player_address : INET_ADDRESS
		ad : INET_ADDRESS_FACTORY
		answer : STRING
		worked_well : BOOLEAN
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create new_player1.make ("Test1",23456,1)
		create new_player2.make ("Test2",23457,1)
		create new_player3.make ("Test3",23458,2)
		create ad.default_create
		new_player_address :=  ad.create_localhost
		answer := server.treat_joining_request(new_player1,new_player_address)
		print("First answer (to join) : " + answer + "%N")
		answer := server.treat_joining_request(new_player2,new_player_address)
		print("Second answer (to join) : " + answer + "%N")
		answer := server.treat_joining_request(new_player3,new_player_address)
		print("Third answer (to join) : " + answer + "%N")
		answer := server.treat_start_game_request
		print("Fourth answer (to start game) : " + answer + "%N")
		worked_well := answer.is_equal ("REJECT_NOT_ENOUGH_PLAYERS")
		print("answer = REJECT_NOT_ENOUGH_PLAYERS : " + worked_well.out + "%N")
		assert("test_treat_start_game_request_2", worked_well)
	end

	test_treat_start_game_request_3
	local
		server : TR_SERVER_THREAD
		player1,player2,player3,player4 : TR_CHANGING_PLAYER
		new_player1 : TR_JOINING_PLAYER
		new_player2 : TR_JOINING_PLAYER
		new_player3 : TR_JOINING_PLAYER
		new_player4 : TR_JOINING_PLAYER
		new_player_address : INET_ADDRESS
		ad : INET_ADDRESS_FACTORY
		answer : STRING
		worked_well : BOOLEAN
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create new_player1.make ("Test1",23456,1)
		create player1.make_for_ready_state_change ("Test1", true)
		create new_player2.make ("Test2",23457,1)
		create player2.make_for_ready_state_change ("Test2", true)
		create new_player3.make ("Test3",23458,2)
		create player3.make_for_ready_state_change ("Test3", true)
		create new_player4.make ("Test4",23459,2)
		create player4.make_for_ready_state_change ("Test4", true)
		create ad.default_create
		new_player_address :=  ad.create_localhost
		answer := server.treat_joining_request(new_player1,new_player_address)
		print("First answer (to join) : " + answer + "%N")
		answer := server.treat_changing_ready_state_request (player1)
		print("Is ready : " + answer + "%N")
		answer := server.treat_joining_request(new_player2,new_player_address)
		print("Second answer (to join) : " + answer + "%N")
		answer := server.treat_changing_ready_state_request (player2)
		print("Is ready : " + answer + "%N")
		answer := server.treat_joining_request(new_player3,new_player_address)
		print("Third answer (to join) : " + answer + "%N")
		answer := server.treat_changing_ready_state_request (player3)
		print("Is ready : " + answer + "%N")
		answer := server.treat_joining_request(new_player4,new_player_address)
		print("Fourth answer (to join) : " + answer + "%N")
		answer := server.treat_changing_ready_state_request (player4)
		print("Is ready : " + answer + "%N")
		answer := server.treat_start_game_request
		print("Fifth answer (to start game) : " + answer + "%N")
		worked_well := answer.is_equal ("OK_START_GAME")
		print("answer = OK_START_GAME : " + worked_well.out + "%N")
		assert("test_treat_start_game_request_3", worked_well)
	end

	test_treat_start_game_request_4
	local
		server : TR_SERVER_THREAD
		new_player1 : TR_JOINING_PLAYER
		new_player2 : TR_JOINING_PLAYER
		new_player3 : TR_JOINING_PLAYER
		new_player4 : TR_JOINING_PLAYER
		new_player_address : INET_ADDRESS
		ad : INET_ADDRESS_FACTORY
		answer : STRING
		worked_well : BOOLEAN
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create new_player1.make ("Test1",23456,1)
		create new_player2.make ("Test2",23457,1)
		create new_player3.make ("Test3",23458,2)
		create new_player4.make ("Test4",23459,1)
		create ad.default_create
		new_player_address :=  ad.create_localhost
		answer := server.treat_joining_request(new_player1,new_player_address)
		print("First answer (to join) : " + answer + "%N")
		answer := server.treat_joining_request(new_player2,new_player_address)
		print("Second answer (to join) : " + answer + "%N")
		answer := server.treat_joining_request(new_player3,new_player_address)
		print("Third answer (to join) : " + answer + "%N")
		answer := server.treat_joining_request(new_player4,new_player_address)
		print("Fourth answer (to join) : " + answer + "%N")
		answer := server.treat_start_game_request
		print("Fifth answer (to start game) : " + answer + "%N")
		worked_well := answer.is_equal ("REJECT_TEAMS_NOT_MADE")
		print("answer = REJECT_TEAMS_NOT_MADE : " + worked_well.out + "%N")
		assert("test_treat_start_game_request_4", worked_well)
	end

	feature -- test for TR_SERVER_THREAD treat_quit_connection_phase_request

	test_treat_quit_connection_phase_request
	local
		server : TR_SERVER_THREAD
		new_player : TR_JOINING_PLAYER
		changing_player : TR_CHANGING_PLAYER
		new_player_address : INET_ADDRESS
		ad : INET_ADDRESS_FACTORY
		answer : STRING
		worked_well : BOOLEAN
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create new_player.make ("Test",23456,1)
		create changing_player.make ("Test", 2)
		create ad.default_create
		new_player_address :=  ad.create_localhost
		answer := server.treat_joining_request(new_player,new_player_address)
		print("First answer : " + answer + "%N")
		answer := server.treat_quit_connection_phase_request (new_player.name)
		print("Second answer : " + answer + "%N")
		worked_well := answer.is_equal ("OK_QUIT_CONNECTION_PHASE")
		worked_well := worked_well
		assert("test_treat_changing_team_request_1", worked_well)
	end


feature -- other tests

	test_server_player_set_team_1
		-- test if the set_team method works
	local
		server_player: TR_SERVER_PLAYER
		team_id: INTEGER
	do
		team_id := 1
		create server_player.make_complete("Good guy", team_id, Void,1,False)
		assert("Team in constructor", server_player.team = team_id)
	end

	test_server_player_set_team_2
		-- test if the set_team method works
	local
		server_player: TR_SERVER_PLAYER
		team_id: INTEGER
	do
		team_id := 1
		create server_player.make_complete("Good guy", team_id, Void,1,False)
		team_id := 2
		server_player.set_team(team_id)
		assert("Team in set_team", server_player.team = team_id)
	end

	test_answer_for_routing_request
	local
		packet : TR_PACKET
		server : TR_SERVER_THREAD
		worked_well : BOOLEAN
		answer : STRING
		server_player : TR_SERVER_PLAYER
		list: LINKED_LIST [STRING]

		ad : INET_ADDRESS_FACTORY

		request : TR_CLIENT_REQUEST
		new_player : TR_SERVER_PLAYER
		changing_player : TR_CHANGING_PLAYER
	do
		print("Creating server%N")
		create server.make_server_on_free_port
		create ad

		create new_player.make_complete ("Test", 1, ad.create_localhost, 1, False)
		create changing_player.make_for_quit ("Test")
		create request.make ("QUIT_CONNECTION_PHASE", changing_player)
		create list.make
		list.extend ("Test1")
		create packet.make (list, request)
		answer := server.answer_for_routing_request (packet)
		worked_well := answer.is_equal ("REJECT_PLAYER_NOT_FOUND")
		assert("answer_for_routing_request_ok", worked_well)
	end




end

