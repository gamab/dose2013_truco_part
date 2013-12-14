note
	description: "Test for class Client."
	author: "Justine Compagnon"
	date: "06/11/2013"
	revision: ""

class
	TR_CLIENT_TEST

inherit
	EQA_TEST_SET

feature {ANY} -- Test routing control

--test_make_with_param
--	local
--		client : TR_CLIENT
--		cur_controller : TR_CONTROLLER
--		cur_server_adress : INET_ADDRESS
--		cur_server_port : INTEGER
--		worked_well : BOOLEAN
--	do
--		create client.make_with_param (cur_controller, cur_server_adress, cur_server_port)

--	end


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
