note
	description: "Test routines TR_CHAT_LINE and TR_CHAT"
	author: "Justine Compagnon"
	date: "$19/11/2013$"
	revision: ""

class
	TR_TEST_CHAT

inherit
	EQA_TEST_SET

feature -- Test routines TR_CHAT_LINE

   test_chat_line_make_filled
	-- check if the constructer is doing it job
	local
		line : TR_CHAT_LINE
		worked_well : BOOLEAN
		player : TR_PLAYER
	do
		worked_well := false
		create player.make (1, 1)
		player.set_player_name ("Test")
		create line.make_filled (player, "coucou")
		if line.player.get_player_name.is_equal ("Test") and line.message.is_equal ("coucou") then
			worked_well := true
		end

		assert("chat_line_make_filled Ok", worked_well)
	end


	test_chat_line_out_1
	-- test for a consistence message
	local
		line : TR_CHAT_LINE
		worked_well : BOOLEAN
		player : TR_PLAYER
	do
		worked_well := false
		create player.make (1, 1)
		player.set_player_name ("Test")
		create line.make_filled (player, "coucou")
		print(line.out)
		if line.out.is_equal ("Test : coucou") then
			worked_well := true
		end
		assert("chat_line_make Ok", worked_well)
	end

	test_chat_line_out_2
	-- test for an empty message
	local
		line : TR_CHAT_LINE
		worked_well : BOOLEAN
		player : TR_PLAYER
	do
		worked_well := false
		create player.make (1, 1)
		player.set_player_name ("Test")
		create line.make_filled (player, "")
		print(line.out)
		if line.out.is_equal ("Test : ") then
			worked_well := true
		end
		assert("chat_line_make Ok", worked_well)
	end


feature -- Test routines TR_CHAT


--	test_chat_make
--	local
--		chat1:TR_CHAT
--		worked_well:BOOLEAN
--	do
--		worked_well := false
--		create chat1.make
--		if chat1.messages.is_empty then
--			worked_well := true
--		end
-- 		assert("chat_make Ok", worked_well)
--	end




--	test_chat_add_line
--	 local
--        chat1:TR_CHAT
--        line, line1:TR_CHAT_LINE
--        worked_well:BOOLEAN
--        player, player2: TR_PLAYER
--    do
--        worked_well := false
--        create player.make (1, 1)
--        player.set_player_name ("Test1")
--        create player2.make (2, 1)
--        player2.set_player_name ("Test2")
--        create chat1.make
--        create line1.make_filled (player2, "coucou")
--        create line.make_filled (player, "coucou")
--        chat1.add_line (line)
--        chat1.add_line (line1)
--        print(chat1.messages.first.out + "%N")
--        print(chat1.messages.last.out)
--        if chat1.messages.first.out.is_equal ("Test1 : coucou") AND chat1.messages.last.out.is_equal ("Test2 : coucou") then
--        	worked_well := true
--        end

--        assert("chat_out Ok", worked_well)

--    end



--    test_chat_out_1
--    -- out a list with element
--    local
--        chat1:TR_CHAT
--        line, line1:TR_CHAT_LINE
--        worked_well:STRING
--        player,player2: TR_PLAYER
--    do
--        worked_well := ""
--        create player.make (1, 1)
--        player.set_player_name ("Test1")
--        create player2.make (2, 1)
--        player2.set_player_name ("Test2")
--        create chat1.make
--        create line1.make_filled (player2, "coucou")
--        create line.make_filled (player, "coucou")
--        chat1.add_line (line)
--        print(chat1.out + "%N")
--        chat1.add_line (line1)
--        print(chat1.out + "%N")
--        worked_well := "Test1 : coucou" + "%N" + "Test2 : coucou" + "%N"
--        print(worked_well)
--        assert("chat_out Ok", worked_well.is_equal (chat1.out))

--    end


--    test_chat_out_2
--    -- out a list with no element
--    local
--        chat1:TR_CHAT
--        line, line1:TR_CHAT_LINE
--        worked_well:STRING
--    do
--        worked_well := ""
--        create chat1.make
--        assert("chat_out Ok", worked_well.is_equal (chat1.out))

--    end


end
