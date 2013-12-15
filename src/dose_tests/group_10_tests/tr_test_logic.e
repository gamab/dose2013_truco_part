note
	description: "Summary description for {TR_TEST_LOGIC}."
	author: "Justine Compagnon, Matias Donatti"
	date: "12/11/2013"
	revision: ""

class
	TR_TEST_LOGIC

inherit
	EQA_TEST_SET

feature -- Test routines


feature -- test creaters

test_make
	note
		testing: "covers/{TR_LOGIC}.make_cards_random_order"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	worked_well: BOOLEAN
	 do
	 	worked_well := false;
	 	logic.make
	 	-- we check if the teams are initialized correctly
	 	if logic.game_state_obj.get_team1_score = 0 AND logic.game_state_obj.get_team2_score = 0 AND logic.get_current_game_points = 0 then
	 		-- check if all the arrays are correctly set
	 		if logic.cards.count = 40 and logic.get_table_cards.count = 36 AND logic.get_round.count = 3 AND logic.game_state_obj.get_all_players.count = 4 then
	 			if logic.get_current_bet.is_empty AND not logic.get_action AND logic.get_betting_team = 0 then
	 				worked_well := true;
	 			end
	 		end

	 	end
	 	assert ("make ok", worked_well)
	 end


test_make_cards_random_order -- check if there isn't twice the same card in the game generated
	note
		testing: "covers/{TR_LOGIC}.make_cards_random_order"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	worked_well: BOOLEAN
	 	i,j: INTEGER
 	do
		worked_well := true
		create logic.make
		logic.make_cards_random_order()
		from
			i := 0
		until
			i > logic.cards.upper
		loop
			print(logic.cards.at (i).out + "%N")
			from
				j:= i + 1
			until
				j > logic.cards.upper
			loop
				if logic.cards.at (i) = logic.cards.at (j) then
					worked_well := false;
				end
				j := j + 1
			end
			i := i + 1
		end
		assert ("make_cards_with_random_order ok", worked_well)
	end


	 test_get_team_points
	 note
		testing: "covers/{TR_LOGIC}.get_team_points"
		testing: "user/TR" -- this is tag with the class-prefix
	 local
	 	worked_well : BOOLEAN
	 	logic : TR_LOGIC

	 do
	 	create logic.make
	 	logic.add_to_team_points (1, 20 )
	 	if logic.get_team_points (1) = logic.game_state_obj.get_team1_score then
	 		worked_well := true;
	 	end
	 	assert ("make ok", worked_well )
	 end



	test_update_team_score
	note
		testing: "covers/{TR_LOGIC}.update_team_score"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player_1, player_2 : TR_PLAYER
 	do
		create logic.make
		create player_1.make (1, 1)
		create player_2.make (2, 1)
		logic.add_to_team_points (1,2)
		assert ("update_team_score ok", logic.get_team_points (1) = 2)
 	end



	test_get_players()
	note
		testing: "covers/{TR_LOGIC}.get_players"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
 	do
--		create logic.make
--		assert ("get_players ok", logic.get_players = logic.all_players)
 	end



	test_get_cards()
	note
		testing: "covers/{TR_LOGIC}.get_cardsget_cards"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
 	do
		create logic.make
		assert ("get_cards ok", logic.get_cards = logic.cards)
 	end






 	-- if the card is in the deck_card then we suppose play_card worked
 	test_play_card
 		note
		testing: "covers/{TR_LOGIC}.play_card"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	worked_well: BOOLEAN
	 	card: TR_CARD
	 	player: TR_PLAYER

 	do
		create logic.make
		worked_well := false;
		card.make ("sword", 1)
		player.make (1, 1)
		logic.play_card (card, player)
		if logic.cards.has(card) then
			worked_well := true;
		end
		assert ("play_card ok", worked_well)
 	end


 	test_get_table_card
 	note
		testing: "covers/{TR_LOGIC}.get_table_card"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
 	do
		create logic.make
		assert ("get_table_card ok", logic.get_table_cards = logic.get_table_cards )
 	end





feature -- test for : is_truco_allowed is_retruco_allowed is_vale_cuatro_allowed

 	test_is_truco_allowed_1
 	note
		testing: "covers/{TR_LOGIC}.is_truco_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
		truco_allowed : BOOLEAN
 	do
		create logic.make
		create player.make (1,1)
		truco_allowed := logic.is_truco_allowed (player)
		assert ("is_truco_allowed_1 ok", truco_allowed )
 	end

 	test_is_truco_allowed_2
 	note
		testing: "covers/{TR_LOGIC}.is_truco_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
		truco_allowed : BOOLEAN
 	do
		create logic.make
		create player.make (1,1)
		create player2.make (2,2)
		truco_allowed := logic.is_truco_allowed (player)
		logic.send_truco (1)
		truco_allowed := logic.is_truco_allowed (player2)
		assert ("is_truco_allowed_2 ok", not truco_allowed )
 	end

    test_is_retruco_allowed_1
 	note
		testing: "covers/{TR_LOGIC}.is_retruco_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
		retruco_allowed : BOOLEAN
 	do
		create logic.make
 		create player.make (1, 1)
 		-- retruco is not meant to be allowed if truco has not yet been said
 		retruco_allowed := logic.is_retruco_allowed (player)
 		assert ("is_retruco_allowed_1 ok", not retruco_allowed)
 	end

 	test_is_retruco_allowed_2
 	note
		testing: "covers/{TR_LOGIC}.is_retruco_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
		truco_allowed : BOOLEAN
		retruco_allowed : BOOLEAN
 	do
		create logic.make
 		create player.make (1, 1)
 		-- retruco is not meant to be allowed if truco has been said by the same player
		truco_allowed := logic.is_truco_allowed (player)
		logic.send_truco (1)
 		retruco_allowed := logic.is_retruco_allowed (player)
 		logic.send_re_truco (1)
 		assert ("is_retruco_allowed_2 ok", not retruco_allowed)
 	end

 	test_is_retruco_allowed_3
 	note
		testing: "covers/{TR_LOGIC}.is_retruco_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
		truco_allowed : BOOLEAN
		retruco_allowed : BOOLEAN
 	do
		create logic.make
 		create player.make (1, 1)
 		create player2.make (2, 1)
 		-- retruco is not meant to be allowed if truco has been said by a player in the same team
		truco_allowed := logic.is_truco_allowed (player)
		logic.send_truco (1)
 		retruco_allowed := logic.is_retruco_allowed (player2)
 		logic.send_re_truco (2)
 		assert ("is_retruco_allowed_3 ok", not retruco_allowed)
 	end

 	test_is_retruco_allowed_4
 	note
		testing: "covers/{TR_LOGIC}.is_retruco_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
		truco_allowed : BOOLEAN
		retruco_allowed : BOOLEAN
 	do
		create logic.make
 		create player.make (1, 1)
 		create player2.make (2, 2)
 		-- retruco is meant to be allowed if truco has been said by a player in the other team
		truco_allowed := logic.is_truco_allowed (player)
		logic.send_truco (1)
 		retruco_allowed := logic.is_retruco_allowed (player2)
 		assert ("is_retruco_allowed_4 ok", retruco_allowed)
 	end

    test_is_vale_cuatro_allowed_1
    note
		testing: "covers/{TR_LOGIC}.is_vale_cuatro_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
		vale_cuatro_allowed : BOOLEAN
 	do
		create logic.make
 		create player.make (1, 1)
 		-- vale cuatro is not meant to be allowed if no one said truco and retruco
 		vale_cuatro_allowed := logic.is_vale_cuatro_allowed (player)
 		assert ("is_vale_cuatro_allowed_1", not vale_cuatro_allowed)
 	end

    test_is_vale_cuatro_allowed_2
    note
		testing: "covers/{TR_LOGIC}.is_vale_cuatro_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
		truco_allowed : BOOLEAN
		vale_cuatro_allowed : BOOLEAN
 	do
		create logic.make
 		create player.make (1, 1)
 		create player2.make (2, 2)
 		-- vale cuatro is not meant to be allowed if no one said truco and retruco
 		truco_allowed := logic.is_truco_allowed (player)
 		vale_cuatro_allowed := logic.is_vale_cuatro_allowed (player2)
 		assert ("is_vale_cuatro_allowed_2", not vale_cuatro_allowed)
 	end

 	test_is_vale_cuatro_allowed_3
    note
		testing: "covers/{TR_LOGIC}.is_vale_cuatro_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
		truco_allowed : BOOLEAN
		retruco_allowed : BOOLEAN
		vale_cuatro_allowed : BOOLEAN
 	do
		create logic.make
 		create player.make (1, 1)
 		create player2.make (2, 2)
 		-- vale cuatro is meant to be allowed if someone said truco and the other team said retruco and this someone says vale cuatro
 		truco_allowed := logic.is_truco_allowed (player)
 		logic.send_truco (1)
 		retruco_allowed := logic.is_retruco_allowed (player2)
 		logic.send_re_truco (2)
 		vale_cuatro_allowed := logic.is_vale_cuatro_allowed (player)
 		assert ("is_vale_cuatro_allowed_3", vale_cuatro_allowed)
 	end


 	test_is_vale_cuatro_allowed_4
    note
		testing: "covers/{TR_LOGIC}.is_vale_cuatro_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
		truco_allowed : BOOLEAN
		retruco_allowed : BOOLEAN
		vale_cuatro_allowed : BOOLEAN
 	do
		create logic.make
 		create player.make (1, 1)
 		create player2.make (2, 2)
 		-- vale cuatro is not meant to be allowed if someone said truco and the other team said retruco and the other team says vale cuatro once again
 		truco_allowed := logic.is_truco_allowed (player)
 		logic.send_truco (1)
 		retruco_allowed := logic.is_retruco_allowed (player2)
 		logic.send_re_truco (2)
 		vale_cuatro_allowed := logic.is_vale_cuatro_allowed (player2)
 		assert ("is_vale_cuatro_allowed_4", not vale_cuatro_allowed)
 	end

 	test_is_vale_cuatro_allowed_5
    note
		testing: "covers/{TR_LOGIC}.is_vale_cuatro_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
	 	player3 : TR_PLAYER
		truco_allowed : BOOLEAN
		retruco_allowed : BOOLEAN
		vale_cuatro_allowed : BOOLEAN
 	do
		create logic.make
 		create player.make (1, 1)
 		create player2.make (2, 2)
 		create player3.make (3, 2)
 		-- vale cuatro is not meant to be allowed if someone said truco
 		-- someone from the other team said retruco
 		-- and then someone else from the other team says vale cuatro once again
 		truco_allowed := logic.is_truco_allowed (player)
 		logic.send_truco (1)
 		retruco_allowed := logic.is_vale_cuatro_allowed (player2)
 		logic.send_re_truco (2)
 		vale_cuatro_allowed := logic.is_vale_cuatro_allowed (player3)
 		logic.send_valle_cuatro (3)
 		assert ("is_vale_cuatro_allowed_5", not vale_cuatro_allowed)
 	end


 	test_is_vale_cuatro_allowed_6
    note
		testing: "covers/{TR_LOGIC}.is_vale_cuatro_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
	 	player3 : TR_PLAYER
		truco_allowed : BOOLEAN
		retruco_allowed : BOOLEAN
		vale_cuatro_allowed : BOOLEAN
 	do
		create logic.make
 		create player.make (1, 1)
 		create player2.make (2, 2)
 		create player3.make (3, 1)
 		-- vale cuatro is meant to be allowed if someone said truco
 		-- someone from the other team said retruco
 		-- and then someone else from the first team says vale cuatro once again
 		truco_allowed := logic.is_truco_allowed (player)
 		logic.send_truco (1)
 		retruco_allowed := logic.is_vale_cuatro_allowed (player2)
 		logic.send_re_truco (2)
 		vale_cuatro_allowed := logic.is_vale_cuatro_allowed (player3)
 		assert ("is_vale_cuatro_allowed_6", vale_cuatro_allowed)
 	end


feature -- test for : is_envido_allowed is_real_envido_allowed is_falta_envido_allowed

     test_is_envido_allowed_1
     note
		testing: "covers/{TR_LOGIC}.is_envido_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	 local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
		envido_allowed : BOOLEAN
 	 do
 	 	create logic.make
 	 	create player.make (1, 1)
 	 	-- envido should be allowed if no one said it
 	 	envido_allowed := logic.is_envido_allowed (player)
 		assert ("is_envido_allowed_1 ok", envido_allowed )
 	 end

     test_is_envido_allowed_2
     note
		testing: "covers/{TR_LOGIC}.is_envido_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	 local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
		envido_allowed : BOOLEAN
 	 do
 	 	create logic.make
 	 	create player.make (1, 1)
 	 	create player2.make (2, 2)
 	 	-- envido should not be allowed if someone said it
 	 	envido_allowed := logic.is_envido_allowed (player)
 	 	logic.send_envido (1)
 	 	envido_allowed := logic.is_envido_allowed (player2)
 		assert ("is_envido_allowed_2 ok", not envido_allowed )
 	 end

    test_is_real_envido_allowed_1
	local
	 	logic : TR_LOGIC
	 	player, player2 : TR_PLAYER
		real_envido_allowed : BOOLEAN
	do
 	 	create logic.make
 	 	create player.make (1, 1)
  	 	create player2.make (2, 2)
 	 	--real envido should be allowed if no one said it
 		logic.send_envido (1)
 	 	real_envido_allowed := logic.is_real_envido_allowed (player2)
 		assert ("is_real_envido_allowed_1 ok", real_envido_allowed )
	end

    test_is_real_envido_allowed_2
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2, player3 : TR_PLAYER
		real_envido_allowed : BOOLEAN
	do
 	 	create logic.make
 	 	create player.make (1, 1)
 	 	create player2.make (2, 2)
 	 	create player2.make (3, 1)
 	 	--real envido should not be allowed if someone said it
 	 	logic.send_envido (1)
 	 	real_envido_allowed := logic.is_real_envido_allowed (player2)
 	 	logic.send_re_envido (2)
 	 	real_envido_allowed := logic.is_real_envido_allowed (player3)
 		assert ("is_real_envido_allowed_2 ok", not real_envido_allowed )
	end

	test_is_real_envido_allowed_3
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
		envido_allowed : BOOLEAN
		real_envido_allowed : BOOLEAN
	do
 	 	create logic.make
 	 	create player.make (1, 1)
 	 	create player2.make (2, 2)
 	 	--real envido should be allowed if someone said envido
 	 	envido_allowed := logic.is_envido_allowed (player)
 	 	logic.send_envido (1)
 	 	real_envido_allowed := logic.is_real_envido_allowed (player2)
 		assert ("is_real_envido_allowed_3 ok", real_envido_allowed )
	end

	test_is_real_envido_allowed_4
	local
	 	logic : TR_LOGIC
	 	player : TR_PLAYER
	 	player2 : TR_PLAYER
		envido_allowed : BOOLEAN
		real_envido_allowed : BOOLEAN
	do
 	 	create logic.make
 	 	create player.make (1, 1)
 	 	create player2.make (2, 1)
 	 	--real envido should not be allowed if someone from your team said envido
 	 	envido_allowed := logic.is_envido_allowed (player2)
 	 	logic.send_envido (1)
 	 	real_envido_allowed := logic.is_real_envido_allowed (player2)
 		assert ("is_real_envido_allowed_3 ok", not real_envido_allowed )
	end


   test_is_falta_envido_allowed_1
   note
		testing: "covers/{TR_LOGIC}.is_falta_envido_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	players : ARRAY[TR_PLAYER]
		real_envido_allowed : BOOLEAN
		falta_envido_allowed : BOOLEAN
	do
 	 	create logic.make

 	 	logic.set_player_info ("Player", 1, 1)
 	 	logic.set_player_info ("Player2", 2, 2)
 	 	logic.set_player_info ("Player3", 3, 1)
 	 	logic.set_player_info ("Player4", 4, 2)

 	 	players := logic.get_players

 	 	--falta envido should be allowed if someone said real_envido
 	 	logic.send_envido (1)
 	 	logic.send_re_envido (2)
 	 	falta_envido_allowed := logic.is_falta_envido_allowed (players.at (2))
 		assert ("is_falta_envido_allowed_1 ok", falta_envido_allowed )
 	end

   test_is_falta_envido_allowed_2
   note
		testing: "covers/{TR_LOGIC}.is_falta_envido_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	players : ARRAY[TR_PLAYER]
		real_envido_allowed : BOOLEAN
		falta_envido_allowed : BOOLEAN
	do
		create logic.make

 	 	logic.set_player_info ("Player", 1, 1)
 	 	logic.set_player_info ("Player2", 2, 2)
 	 	logic.set_player_info ("Player3", 3, 1)
 	 	logic.set_player_info ("Player4", 4, 2)

 	 	players := logic.get_players

 	 	--falta envido should be allowed if someone said real_envido
 	 	logic.send_envido (1)
 	 	logic.send_re_envido (2)
 	 	--falta envido should not be allowed if someone said real_envido
 	 	--and someone else from the same team said falta_envido
 	 	falta_envido_allowed := logic.is_falta_envido_allowed (players[1])
 		assert ("is_falta_envido_allowed_2 ok", not falta_envido_allowed )
 	end

   test_is_falta_envido_allowed_3
   note
		testing: "covers/{TR_LOGIC}.is_falta_envido_allowed"
		testing: "user/TR" -- this is tag with the class-prefix
	local
	 	logic : TR_LOGIC
	 	players : ARRAY[TR_PLAYER]
		real_envido_allowed : BOOLEAN
		falta_envido_allowed : BOOLEAN
	do
		create logic.make

 	 	logic.set_player_info ("Player", 1, 1)
 	 	logic.set_player_info ("Player2", 2, 2)
 	 	logic.set_player_info ("Player3", 3, 1)
 	 	logic.set_player_info ("Player4", 4, 2)

 	 	players := logic.get_players

 	 	--falta envido should be allowed if someone said real_envido
 	 	logic.send_envido (1)

 	 	--falta envido should not be allowed if no one said real_envido
 	 	falta_envido_allowed := logic.is_falta_envido_allowed (players[1])
 		assert ("is_falta_envido_allowed_3 ok", not falta_envido_allowed )
 	end



feature -- test for : send_envido send_re_envido send_falta_envido

test_send_envido
	note
		testing: "covers/{TR_LOGIC}.send_envido"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		logic : TR_LOGIC
		worked_well:BOOLEAN
	do
		create logic.make
		worked_well := false
		logic.send_envido (1)
		if logic.get_current_bet.is_equal ("envido") then
			worked_well := true
		end

		assert ("send_envido ok",worked_well)
	end

	test_send_re_envido
	note
		testing: "covers/{TR_LOGIC}.send_re_envido"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		logic : TR_LOGIC
		worked_well:BOOLEAN
		BC: TR_BET_CONSTANTS
	do
		create BC
		create logic.make
		worked_well := false
			logic.send_envido (1)
			logic.send_re_envido (2)
			if logic.get_current_bet.is_equal (BC.real_envido) then
				worked_well := true
			end
		assert ("send_re_envido ok",worked_well)

	end



	test_send_falta_envido
	note
		testing: "covers/{TR_LOGIC}.send_falta_envido"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		logic : TR_LOGIC
		worked_well:BOOLEAN
		players : ARRAY[TR_PLAYER]
	do
		create logic.make

		players := logic.get_players

		logic.set_player_info ("1", 1, 1)
		logic.set_player_info ("2", 2, 2)
		logic.set_player_info ("3", 3, 1)
		logic.set_player_info ("4", 4, 2)

		players.at (0).set_player_posistion (1)
		players.at (1).set_player_posistion (2)
		players.at (2).set_player_posistion (3)
		players.at (3).set_player_posistion (4)

		worked_well := false

		logic.send_envido (1)
		logic.send_accept (2)
		logic.send_re_envido (2)
		logic.send_accept (1)
		logic.send_falta_envido (3)
		print( "Current bet : " + logic.get_current_bet.out + "%N" )
		if logic.get_current_bet.is_equal("faltaenvido") then
			worked_well := true
		end
		assert ("send_falta_envido ok",worked_well)

	end


feature -- test for : send_truco send_re_truco send_vale_cuatro

test_send_truco
	note
		testing: "covers/{TR_LOGIC}.send_truco"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		logic : TR_LOGIC
		worked_well:BOOLEAN
	do
		create logic.make
		worked_well := false
		logic.send_truco (1)
		if logic.get_current_bet.is_equal ("truco") then
			worked_well := true
		end
		assert ("send_truco ok",worked_well)

	end


test_send_re_truco
	note
		testing: "covers/{TR_LOGIC}.send_re_truco"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		logic : TR_LOGIC
		worked_well:BOOLEAN
		BC: TR_BET_CONSTANTS
	do
		create BC
		create logic.make
		worked_well := false
		logic.send_truco (1)
		logic.send_re_truco (2)
		if logic.get_current_bet.is_equal (BC.retruco) then
			worked_well := true
		end
		assert ("send_re_truco",worked_well)
	end


feature -- test for : send_accept send_reject

test_send_accept
	note
		testing: "covers/{TR_LOGIC}.send_accept"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		logic : TR_LOGIC
		worked_well:BOOLEAN
		player, player2: TR_PLAYER
	do
		create logic.make
		create player.make (1, 1)
		create player.make (2, 2)
		worked_well := false
		logic.send_truco (1)
		logic.send_accept (2)
		print ( logic.get_current_bet + "%N")
		print ( logic.get_action.out + "%N")
		if logic.get_current_bet.is_equal ("truco") and logic.get_action = false then
			worked_well := true
		end
		assert ("send_accept ok",worked_well)

	end



	test_send_reject
	note
		testing: "covers/{TR_LOGIC}.send_reject"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		logic : TR_LOGIC
		worked_well:BOOLEAN
		player,player1 : TR_PLAYER
	do
		create logic.make
		create player.make (1, 1)
		create player.make (2, 2)
		worked_well := false
		logic.send_envido (1)
		logic.send_reject (2)
		print ( logic.get_current_bet + "%N")
		print ( logic.get_action.out + "%N")
		if logic.get_current_bet.is_equal ("envido") and logic.get_action = false then
			worked_well := true
		end
		assert ("send_reject ok",worked_well)

	end


	test_is_end_of_game_1 -- a team got 24 point
	note
		testing: "covers/{TR_LOGIC}.send_reject"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		logic : TR_LOGIC
	do
		create logic.make
		logic.add_to_team_points (1, 24)
		assert ("is_end_of_game ok",logic.is_end_of_game())

	end


	test_is_end_of_game_2 -- no team got 24 point
	note
		testing: "covers/{TR_LOGIC}.send_reject"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		logic : TR_LOGIC
	do
		create logic.make
		logic.add_to_team_points (1, 12)
		assert ("is_end_of_game ok",not logic.is_end_of_game())

	end

feature -- test for: update_game_points

 	test_update_game_points_1
 	note
		testing: "covers/{TR_LOGIC}.update_game_points"
		testing: "user/TR"
 	local
 		logic: TR_LOGIC
 		worked_well:BOOLEAN
 		game_points1,game_points2:INTEGER
 	do
 		create logic.make
 		game_points1 := logic.get_current_game_points
 		logic.add_to_game_points (2)
 		game_points2 := logic.get_current_game_points
 		worked_well:= (game_points1+2 = game_points2)
 		assert ("update_game_points ok",worked_well)
 	end

	 	test_update_game_points_2
 	note
		testing: "covers/{TR_LOGIC}.update_game_points"
		testing: "user/TR"
 	local
 		logic: TR_LOGIC
 		worked_well:BOOLEAN
 		game_points1,game_points2:INTEGER
 	do
 		create logic.make
 		game_points1 := logic.get_current_game_points
 		logic.add_to_game_points (2)
 		game_points2 := logic.get_current_game_points
 		worked_well:= not (game_points1 = game_points2+3)
 		assert ("update_game_points ok",worked_well)
 	end

feature -- test for: end_game

 	test_end_game_1
 	note
		testing: "covers/{TR_LOGIC}.end_game"
		testing: "user/TR"
 	local
 		logic: TR_LOGIC
 		worked_well:BOOLEAN
	 	player: TR_PLAYER
 	do
 		create logic.make
 		create player.make (1,1)
		logic.end_game()
		worked_well := logic.is_truco_allowed (player)
 		assert ("end_game ok", not worked_well)
 	end

 	test_end_game_2
 	note
		testing: "covers/{TR_LOGIC}.end_game"
		testing: "user/TR"
 	local
 		logic: TR_LOGIC
 		worked_well:BOOLEAN
	 	player: TR_PLAYER
 	do
 		create logic.make
 		create player.make (1,1)
		logic.end_game()
		worked_well := logic.is_real_envido_allowed (player)
 		assert ("end_game ok", not worked_well)
 	end

feature -- test for: end_hand

 	test_end_hand_1
 	note
		testing: "covers/{TR_LOGIC}.end_hand"
		testing: "user/TR"
 	local
 		logic: TR_LOGIC
 		worked_well:BOOLEAN
	 	player: TR_PLAYER
 	do
 		create logic.make
 		create player.make (1,1)
		logic.end_hand()
		worked_well := logic.is_truco_allowed (player)
 		assert ("end_hand ok", not worked_well)
 	end


	test_end_hand_2
 	note
		testing: "covers/{TR_LOGIC}.end_hand"
		testing: "user/TR"
 	local
 		logic: TR_LOGIC
 		worked_well:BOOLEAN
	 	player: TR_PLAYER
 	do
 		create logic.make
 		create player.make (1,1)
		logic.end_hand()
		worked_well := logic.is_falta_envido_allowed (player)
 		assert ("end_hand ok", not worked_well)
 	end

feature --

	test_put_card
	local
		logic: TR_LOGIC
 		worked_well:BOOLEAN
	 	i : INTEGER
 	do
 		create logic.make
		logic.put_the_cards
		from
			i := 0
		until
			i > 39
		loop
			print(logic.cards[i].out+"%N")
			i := i + 1
		end
		worked_well := logic.cards[logic.cards.lower].get_card_value = 1 and logic.cards[logic.cards.lower].get_card_type.is_equal ("cups")
		worked_well := logic.cards[logic.cards.upper].get_card_value = 12 and logic.cards[logic.cards.upper].get_card_type.is_equal ("clubs")
 		assert ("put_card ok", worked_well)
 	end


end
