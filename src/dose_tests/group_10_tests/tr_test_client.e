note
	description: "Test for class Client."
	author: "Justine Compagnon"
	date: "06/11/2013"
	revision: ""

class
	TR_TEST_CLIENT

inherit
	EQA_TEST_SET

feature {ANY} -- Test creators


	test_make_client
	local
		client : TR_CLIENT
		server_socket : NETWORK_STREAM_SOCKET
		worked_well : BOOLEAN
	do
		print("Creating client")
		create server_socket.make_server_by_port (0)
		create client.make_client


		worked_well := client.server_address = Void
		print("Previous result and server_address set : " + worked_well.out + "%N")
		worked_well := worked_well and client.server_port = 0
		print("Previous result and server_port set : " + worked_well.out + "%N")
		worked_well := worked_well and client.listening_thread.is_last_launch_successful
		print("Previous result and thread launched : " + worked_well.out + "%N")

		assert("make with param sets everything well :",worked_well)
	end


--	test_make_with_param
--	local
--		client : TR_CLIENT
--		empty_controller : TR_CONTROLLER
--		server_socket : NETWORK_STREAM_SOCKET
--		worked_well : BOOLEAN
--	do
--		print("Creating client")
--		create server_socket.make_server_by_port (0)
--		create client.make_with_param (empty_controller, server_socket.address.host_address, server_socket.port)


--		worked_well := client.controller = empty_controller
--		print("Controller set : " + worked_well.out + "%N")
--		worked_well := worked_well and client.server_address.is_equivalent (server_socket.address.host_address)
--		print("Previous result and server_address set : " + worked_well.out + "%N")
--		worked_well := worked_well and client.server_port = server_socket.port
--		print("Previous result and server_port set : " + worked_well.out + "%N")
--		worked_well := worked_well and client.listening_thread.is_last_launch_successful
--		print("Previous result and thread launched : " + worked_well.out + "%N")
--		worked_well := worked_well and client.players.count = 4
--		print("Previous result and array of players created : " + worked_well.out + "%N")

--		assert("make with param sets everything well :",worked_well)
--	end

--	test_make_with_less_param
--	local
--		client : TR_CLIENT
--		empty_controller : TR_CONTROLLER
--		worked_well : BOOLEAN
--	do
--		print("Creating client")
--		create client.make_with_less_param (empty_controller)

--		worked_well := client.controller = empty_controller
--		print("Controller set : " + worked_well.out + "%N")
--		worked_well := worked_well and client.listening_thread.is_last_launch_successful
--		print("Previous result and thread launched : " + worked_well.out + "%N")
--		worked_well := worked_well and client.players.count = 4
--		print("Previous result and array of players created : " + worked_well.out + "%N")

--		assert("make with less param sets everything well :",worked_well)
--	end


feature {ANY} -- Test send object to server

--	test_send_object_to_server
--	local
--		client : TR_CLIENT
--		empty_controller : TR_CONTROLLER

--		server : TR_SERVER_THREAD

--		joining_player : TR_JOINING_PLAYER
--		request_to_join : TR_CLIENT_REQUEST
--		packet_to_send : TR_PACKET
--		receivers : LINKED_LIST[STRING]
--		answer_from_server : STRING

--		worked_well : BOOLEAN
--	do
--		print("Creating client %N")
--		create client.make_with_less_param (empty_controller)
--		print("Creating server %N")
--		create server.make_server_with_controller (empty_controller)
--		print("Giving server's ip and port %N")
--		client.set_server_adress_and_port (server.listen_socket.address.host_address, server.listen_socket.port)
--		print("Creating a test joining player %N")
--		create joining_player.make ("Test", client.client_port, 1)
--		print("Creating an empty receivers list %N")
--		create receivers.make
--		print("Creating th request to join %N")
--		create request_to_join.make ("JOIN_GAME", joining_player)
--		print("Creating the packet to send %N")
--		create packet_to_send.make (receivers,request_to_join)

--		print("Launching the server %N")
--		server.launch
--		print("Sending him the request to join %N")
--		answer_from_server := client.send_object_to_server (packet_to_send)
--		worked_well := answer_from_server.is_equal ("PLAYER_ADDED")


--		assert("send joining request to server worked :",worked_well)
--	end

feature {ANY} -- Test routing control

--	test_add_line_to_chat
--	local
--		client : TR_CLIENT
--		cur_controller : TR_CONTROLLER
--		cur_server_adress : INET_ADDRESS
--		cur_server_port : INTEGER
--		line: TR_CHAT_LINE
--		worked_well : BOOLEAN

--	do
--		create client.make_with_param (cur_controller, cur_server_adress, cur_server_port)
--		line.make_filled ("ju", "coucou")
--		client.add_line_to_chat(line)
--		print(client.chat.out)

--		if client.chat.out.is_equal ("coucou") then
--			worked_well := true
--		end
--		assert ("add_line_to_chat ok", worked_well )
--	end

end
