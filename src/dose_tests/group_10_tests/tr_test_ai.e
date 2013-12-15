--note
--	description: "[
--		Eiffel tests that can be executed by testing tool.
--	]"
--	author: "ITU10, RIOCUARTO5"
--	date: "$Date$"
--	revision: "$Revision$"
--	testing: "type/manual"

class
	TR_TEST_AI

inherit
	EQA_TEST_SET

feature {NONE} -- Access

	ai: TR_AI
	BC: TR_BET_CONSTANTS

feature {NONE} -- Events


feature -- Test routines


feature-- test_two_older_card
	test_two_older_card_2
	note
		testing: "covers/{TR_AI}.two_older_card_2"
		testing: "user/TR"
	local
		card_1, card_2, card_3, card_4, card_5, card_6 : TR_CARD
		current_cards : ARRAY[TR_CARD]
		partner_cards : ARRAY[TR_CARD]
		worked_well : BOOLEAN
	do
		--create make
		create ai.make_ai_with_players("difficult",2,4,2)

		--create array cards player current
		create current_cards.make_filled (Void,0,2)

		--create cards
     	create card_1.make ("swords", 1)
		create card_2.make ("clubs", 1)
		create card_3.make ("golds", 5)

		current_cards[0] := card_1
		current_cards[1] := card_2
		current_cards[2] := card_3

		--create array cards player partner
		create partner_cards.make_filled (Void,0,2)

		--create cards
     	create card_4.make ("swords", 4)
		create card_5.make ("clubs", 4)
		create card_6.make ("golds", 4)

		partner_cards[0] := card_1
		partner_cards[1] := card_2
		partner_cards[2] := card_3

		worked_well := ai.two_older_cards (current_cards, partner_cards, 8) = true
		assert("Ok", worked_well)
	end

	test_two_older_card_1
	note
		testing: "covers/{TR_AI}.two_older_card_1"
		testing: "user/TR"
	local
		card_1, card_2, card_3, card_4, card_5, card_6 : TR_CARD
		current_cards : ARRAY[TR_CARD]
		partner_cards : ARRAY[TR_CARD]
		worked_well : BOOLEAN
	do
		--create make
		create ai.make_ai_with_players("difficult",2,4,2)

		--create array cards player current
		create current_cards.make_filled (Void,0,2)

		--create cards
     	create card_1.make ("swords", 5)
		create card_2.make ("clubs", 5)
		create card_3.make ("golds", 5)

		current_cards[0] := card_1
		current_cards[1] := card_2
		current_cards[2] := card_3

		--create array cards player partner
		create partner_cards.make_filled (Void,0,2)

		--create cards
     	create card_4.make ("swords", 4)
		create card_5.make ("clubs", 4)
		create card_6.make ("golds", 4)

		partner_cards[0] := card_1
		partner_cards[1] := card_2
		partner_cards[2] := card_3

		worked_well := ai.two_older_cards (current_cards, partner_cards, 8) = false
		assert("Ok", worked_well)
	end



feature --this_this_card_played

	test_this_card_played_1
	note
		testing: "covers/{TR_AI}.this_card_played_1"
		testing: "user/TR"
	local
		card_1, card_2, card_3 : TR_CARD
		current_cards : ARRAY[TR_CARD]
		partner_cards : ARRAY[TR_CARD]
		worked_well : BOOLEAN
	do
		--create make
		create ai.make_ai_with_players("difficult",2,4,2)

		--create array cards player current
		create current_cards.make_filled (Void,0,2)

		--create cards
     	create card_1.make ("swords", 5)
		create card_2.make ("clubs", 5)
		create card_3.make ("golds", 5)

		current_cards[0] := card_1
		current_cards[1] := card_2
		current_cards[2] := card_3

		worked_well := ai.this_card_played (13, current_cards) = false

		assert("Ok", worked_well)

	end


	test_this_card_played_2
	note
		testing: "covers/{TR_AI}.this_card_played_2"
		testing: "user/TR"
	local
		card_1, card_2, card_3 : TR_CARD
		current_cards : ARRAY[TR_CARD]
		partner_cards : ARRAY[TR_CARD]
		worked_well : BOOLEAN
	do
		--create make
		create ai.make_ai_with_players("difficult",2,4,2)

		--create array cards player current
		create current_cards.make_filled (Void,0,2)

		--create cards
     	create card_1.make ("swords", 1)
		create card_2.make ("golds", 7)
		create card_3.make ("clubs", 1)

		current_cards[0] := card_1
		current_cards[1] := card_2
		current_cards[2] := card_3

		worked_well := ai.this_card_played (13, current_cards) and
						ai.this_card_played (10 , current_cards) and
						ai.this_card_played (12 , current_cards)

		assert("Ok", worked_well)

	end


feature--test_cards_available
	test_card_available
	note
		testing: "covers/{TR_AI}.card_available"
		testing: "user/TR"
	local
		card_1, card_2, card_3 : TR_CARD
		cards_1 : ARRAY[TR_CARD]
		cards_2 : ARRAY[BOOLEAN]
		i : INTEGER
		worked_well : BOOLEAN
		array_result : ARRAY[TR_CARD]
		array_result_void : ARRAY[TR_CARD]
	do
		--create make
		create ai.make_ai_with_players("difficult",2,4,2)
		--create array cards
		create cards_1.make_filled (Void,0,2)
		create cards_2.make_filled (false,0,2)
		--create cards
     	create card_1.make ("swords", 1)
		create card_2.make ("gold", 4)
		create card_3.make ("gold", 5)

		cards_1[0] := card_1
		cards_1[1] := card_2
		cards_1[2] := card_3

		print (worked_well.out + "%N")
		print ("antes card_avail" + "%N")
		array_result := ai.card_available(cards_1,cards_2)

		worked_well := array_result.count = 3

		from
			i := array_result.lower
		until
			i > array_result.upper or not worked_well
		loop
			worked_well := array_result.at (i).get_card_value = cards_1.at (i).get_card_value
			worked_well := worked_well and array_result.at (i).get_card_type.is_equal(cards_1.at (i).get_card_type)
			i := i + 1
		end


		print ("Pase card_avail" + "%N")
		print (worked_well.out + "%N")
		assert ("ok", worked_well)
	end

--easy
	test_card_available_2
	note
		testing: "covers/{TR_AI}.card_available"
		testing: "user/TR"
	local
		card_1, card_2, card_3 : TR_CARD
		cards_1 : ARRAY[TR_CARD]
		cards_2 : ARRAY[BOOLEAN]
		i : INTEGER
		worked_well : BOOLEAN
		array_result : ARRAY[TR_CARD]
		array_result_void : ARRAY[TR_CARD]
	do
		--create make
		create ai.make_ai_with_players("easy",2,4,2)
		--create array cards
		create cards_1.make_filled (Void,0,2)
		create cards_2.make_filled (false,0,2)
		--create cards
     	create card_1.make ("swords", 1)
		create card_2.make ("gold", 4)
		create card_3.make ("gold", 5)

		cards_1[0] := card_1
		cards_1[1] := card_2
		cards_1[2] := card_3

		array_result := ai.card_available(cards_1,cards_2)

		worked_well := array_result.count = 3

		from
			i := array_result.lower
		until
			i > array_result.upper or not worked_well
		loop
			worked_well := array_result.at (i).get_card_value = cards_1.at (i).get_card_value
			worked_well := worked_well and array_result.at (i).get_card_type.is_equal(cards_1.at (i).get_card_type)
			i := i + 1
		end


		print ("Pase card_avail" + "%N")
		print (worked_well.out + "%N")
		assert ("ok", worked_well)
	end


feature--test_random
	test_random
	note
		testing: "covers/{TR_AI}.card_available"
		testing: "user/TR"
	local
		worked_well : BOOLEAN
	do
		create ai.make_ai_with_players ("easy",2,4,2)
		print (worked_well.out + "%N")
		worked_well := ai.random_boolean
		assert ("ok", true)
		print (worked_well.out + "%N")
	end


feature -- test_insertion_sort_by_weight_truco

	test_insertion_sort_by_weight_truco
	note
		testing: "covers/{TR_AI}.insertion_sort_by_weight_truco"
		testing: "user/TR"
	local
		card1,card2,card3: TR_CARD
		cards: ARRAY[TR_CARD]
		worked: BOOLEAN
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",7)
		create card2.make ("clubs",7)
		create card3.make ("swords",7)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower]:=card1
		cards[cards.lower+1]:=card2
		cards[cards.upper]:=card3
		ai.insertion_sort_by_weight_truco(cards)
		worked := cards[cards.lower].get_card_weight_truco <= cards[cards.lower+1].get_card_weight_truco
		worked := worked AND cards[cards.lower+1].get_card_weight_truco <= cards[cards.upper].get_card_weight_truco
		assert ("insertion_sort_by_weight_truco ok", worked)
	end

	test_insertion_sort_by_weight_truco_2
	local
		worked_well : BOOLEAN
		cards: ARRAY[TR_CARD]
		card1, card2, card3 : TR_CARD
	do
		create ai.make_ai_with_players("easy",2,4,2)
		worked_well := false
	 	create card1.make ("golds", 12)
		create card2.make ("golds", 6)
		create card3.make ("swords", 1)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower] := card1
		cards[cards.lower+1] := card2
		cards[cards.upper] := card3
		ai.insertion_sort_by_weight_truco (cards)
		print(cards.at (0).get_card_value.out + " weight :" + cards.at (0).get_card_weight_truco.out + "%N")
		print(cards.at (1).get_card_value.out + " weight :" + cards.at (1).get_card_weight_truco.out + "%N")
		print(cards.at (2).get_card_value.out + " weight :" + cards.at (2).get_card_weight_truco.out + "%N")
		if cards.at (0).get_card_value = 6 and cards.at (1).get_card_value = 12 and cards.at (2).get_card_value = 1 then
			worked_well := true
		end
		assert ("test_insertion_sort_by_weight_truco", worked_well)
	end

	test_insertion_sort_by_weight_truco_3
	local
		worked_well : BOOLEAN
		cards: ARRAY[TR_CARD]
		card1, card2, card3 : TR_CARD
	do
		create ai.make_ai_with_players("easy",2,4,2)
		worked_well := false
		create card1.make ("swords", 1)
	 	create card2.make ("golds", 12)
		create card3.make ("golds", 6)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower] := card1
		cards[cards.lower+1] := card2
		cards[cards.upper] := card3
		ai.insertion_sort_by_weight_truco (cards)
		print(cards.at (0).get_card_value.out + " weight :" + cards.at (0).get_card_weight_truco.out + "%N")
		print(cards.at (1).get_card_value.out + " weight :" + cards.at (1).get_card_weight_truco.out + "%N")
		print(cards.at (2).get_card_value.out + " weight :" + cards.at (2).get_card_weight_truco.out + "%N")
		if cards.at (0).get_card_value = 6 and cards.at (1).get_card_value = 12 and cards.at (2).get_card_value = 1 then
			worked_well := true
		end
		assert ("test_insertion_sort_by_weight_truco", worked_well)
	end

	test_insertion_sort_by_weight_truco_4
	local
		worked_well : BOOLEAN
		cards: ARRAY[TR_CARD]
		card1, card2, card3 : TR_CARD
	do
		create ai.make_ai_with_players("easy",2,4,2)
		worked_well := false
		create card1.make ("golds", 6)
		create card2.make ("swords", 1)
	 	create card3.make ("golds", 12)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower] := card1
		cards[cards.lower+1] := card2
		cards[cards.upper] := card3
		ai.insertion_sort_by_weight_truco (cards)
		print(cards.at (0).get_card_value.out + " weight :" + cards.at (0).get_card_weight_truco.out + "%N")
		print(cards.at (1).get_card_value.out + " weight :" + cards.at (1).get_card_weight_truco.out + "%N")
		print(cards.at (2).get_card_value.out + " weight :" + cards.at (2).get_card_weight_truco.out + "%N")
		if cards.at (0).get_card_value = 6 and cards.at (1).get_card_value = 12 and cards.at (2).get_card_value = 1 then
			worked_well := true
		end
		assert ("test_insertion_sort_by_weight_truco", worked_well)
	end

feature -- calculate_points

	test_calculate_points
	note
		testing: "covers/{TR_AI}.calculate_points"
		testing: "user/TR"
	local
		card1,card2,card3: TR_CARD
		cards: ARRAY[TR_CARD]
		worked: BOOLEAN
		points : INTEGER
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",7)
		create card2.make ("clubs",7)
		create card3.make ("golds",1)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower]:=card1
		cards[cards.lower+1]:=card2
		cards[cards.upper]:=card3
		points := ai.calculate_points(cards)
		worked := points = 28
		assert ("calculate_points ok", worked)
	end

	test_calculate_points2
	note
		testing: "covers/{TR_AI}.calculate_points"
		testing: "user/TR"
	local
		card1,card2,card3: TR_CARD
		cards: ARRAY[TR_CARD]
		worked: BOOLEAN
		points : INTEGER
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",7)
		create card2.make ("clubs",7)
		create card3.make ("swords",7)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower]:=card1
		cards[cards.lower+1]:=card2
		cards[cards.upper]:=card3
		points := ai.calculate_points(cards)
		worked := points = 7
		assert ("calculate_points ok", worked)
	end

	test_calculate_points3
	note
		testing: "covers/{TR_AI}.calculate_points"
		testing: "user/TR"
	local
		card1,card2,card3: TR_CARD
		cards: ARRAY[TR_CARD]
		worked: BOOLEAN
		points : INTEGER
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",10)
		create card2.make ("clubs",11)
		create card3.make ("swords",12)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower]:=card1
		cards[cards.lower+1]:=card2
		cards[cards.upper]:=card3
		points := ai.calculate_points(cards)
		worked := points = 0
		assert ("calculate_points ok", worked)
	end

feature -- greater_card_available

	test_greater_card_available
	note
		testing: "covers/{TR_AI}.greater_card_available"
		testing: "user/TR"
	local
		card1,card2,card3, card_gr: TR_CARD
		cards: ARRAY[TR_CARD]
		played_cards: ARRAY[BOOLEAN]
		worked: BOOLEAN
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",7)
		create card2.make ("clubs",7)
		create card3.make ("swords",7)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower]:=card1
		cards[cards.lower+1]:=card2
		cards[cards.upper]:=card3
		ai.insertion_sort_by_weight_truco(cards)
		create played_cards.make_filled (False, 0, 2)
		played_cards[played_cards.upper]:= True
		card_gr := ai.greater_card_available (cards, played_cards)
		worked := card_gr.get_card_type.is_equal ("golds") AND card_gr.get_card_value = 7
		assert ("greater_card_available ok", worked)
	end

feature -- smaller_card_available

	test_smaller_card_available
	note
		testing: "covers/{TR_AI}.smaller_card_available"
		testing: "user/TR"
	local
		card1,card2,card3, card_gr: TR_CARD
		cards: ARRAY[TR_CARD]
		played_cards: ARRAY[BOOLEAN]
		worked: BOOLEAN
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",7)
		create card2.make ("clubs",7)
		create card3.make ("swords",7)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower]:=card1
		cards[cards.lower+1]:=card2
		cards[cards.upper]:=card3
		ai.insertion_sort_by_weight_truco(cards)
		create played_cards.make_filled (False, 0, 2)
		played_cards[played_cards.lower]:= True
		card_gr := ai.smaller_card_available (cards, played_cards)
		worked := card_gr.get_card_type.is_equal ("golds") AND card_gr.get_card_value = 7
		assert ("smaller_card_available ok", worked)
	end

feature -- optimal_card_to_play

	test_optimal_card_to_play
	note
		testing: "covers/{TR_AI}.optimal_card_to_play"
		testing: "user/TR"
	local
		card1,card2,card3,card_op, card_gr: TR_CARD
		cards: ARRAY[TR_CARD]
		played_cards: ARRAY[BOOLEAN]
		worked: BOOLEAN
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",3)
		create card2.make ("clubs",12)
		create card3.make ("swords",7)
		create card_op.make ("swords",2)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower]:=card1
		cards[cards.lower+1]:=card2
		cards[cards.upper]:=card3
		ai.insertion_sort_by_weight_truco(cards)
		create played_cards.make_filled (False, 0, 2)
		card_gr := ai.optimal_card_to_play (cards, played_cards,card_op)
		worked := card_gr.get_card_type.is_equal ("golds") AND card_gr.get_card_value = 3
		assert ("optimal_card_to_play ok", worked)
	end

	test_optimal_card_to_play2
	note
		testing: "covers/{TR_AI}.optimal_card_to_play"
		testing: "user/TR"
	local
		card1,card2,card3,card_op, card_gr: TR_CARD
		cards: ARRAY[TR_CARD]
		played_cards: ARRAY[BOOLEAN]
		worked: BOOLEAN
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",10)
		create card2.make ("clubs",11)
		create card3.make ("swords",3)
		create card_op.make ("swords",1)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower]:=card1
		cards[cards.lower+1]:=card2
		cards[cards.upper]:=card3
		ai.insertion_sort_by_weight_truco(cards)
		create played_cards.make_filled (False, 0, 2)
		card_gr := ai.optimal_card_to_play (cards, played_cards,card_op)
		worked := card_gr.get_card_type.is_equal ("golds") AND card_gr.get_card_value = 10
		assert ("optimal_card_to_play ok", worked)
	end

	test_optimal_card_to_play3
	note
		testing: "covers/{TR_AI}.optimal_card_to_play"
		testing: "user/TR"
	local
		card1,card2,card3,card_op, card_gr: TR_CARD
		cards: ARRAY[TR_CARD]
		played_cards: ARRAY[BOOLEAN]
		worked: BOOLEAN
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",3)
		create card2.make ("clubs",2)
		create card3.make ("swords",7)
		create card_op.make ("swords",1)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower]:=card1
		cards[cards.lower+1]:=card2
		cards[cards.upper]:=card3
		ai.insertion_sort_by_weight_truco(cards)
		create played_cards.make_filled (False, 0, 2)
		played_cards[played_cards.lower]:= True
		played_cards[played_cards.lower+1]:= True
		card_gr := ai.optimal_card_to_play (cards, played_cards,card_op)
		worked := card_gr.get_card_type.is_equal ("swords") AND card_gr.get_card_value = 7
		assert ("optimal_card_to_play ok", worked)
	end

feature -- mark_a_card

	test_mark_a_card
	note
		testing: "covers/{TR_AI}.mark_a_card"
		testing: "user/TR"
	local
		card1,card2,card3,card_mk: TR_CARD
		cards: ARRAY[TR_CARD]
		played_cards: ARRAY[BOOLEAN]
		worked: BOOLEAN
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",3)
		create card2.make ("clubs",12)
		create card3.make ("swords",7)
		create card_mk.make ("golds",3)
		create cards.make_filled (Void, 0, 2)
		cards[cards.lower]:=card1
		cards[cards.lower+1]:=card2
		cards[cards.upper]:=card3
		ai.insertion_sort_by_weight_truco(cards)
		create played_cards.make_filled (False, 0, 2)
		ai.mark_a_card (card_mk,cards, played_cards)
		worked := (NOT played_cards[played_cards.lower]) AND played_cards[played_cards.lower+1] AND (NOT played_cards[played_cards.upper])
		assert ("mark_a_card ok", worked)
	end

	test_mark_a_card2
	note
		testing: "covers/{TR_AI}.mark_a_card"
		testing: "user/TR"
	local
		card1,card2,card3: TR_CARD
		card_mk1,card_mk2: TR_CARD
		cards: ARRAY[TR_CARD]
		played_cards: ARRAY[BOOLEAN]
		worked: BOOLEAN
	do
		create ai.make_ai_with_players("easy",2,4,2)
		create card1.make ("golds",3)
		create card2.make ("clubs",12)
		create card3.make ("swords",7)
		create card_mk1.make ("golds",3)
		create card_mk2.make ("clubs",12)

		create cards.make_filled (Void, 0, 2)
		cards[0]:=card1
		cards[1]:=card2
		cards[2]:=card3
		ai.insertion_sort_by_weight_truco(cards)
		create played_cards.make_filled (False, 0, 2)
		ai.mark_a_card (card_mk1,cards, played_cards)
		ai.mark_a_card (card_mk2,cards, played_cards)
		worked := played_cards[played_cards.lower] AND played_cards[played_cards.lower+1] AND NOT played_cards[played_cards.upper]
		assert ("mark_a_card ok", worked)
	end

feature -- 	position_in_the_round

	test_position_in_the_round
	note
		testing: "covers/{TR_AI}.position_in_the_round"
		testing: "user/TR"
	local
		player1,player2,player3,player4: TR_PLAYER
		players: ARRAY[TR_PLAYER]
		position: INTEGER
		worked: BOOLEAN
	do
		create ai.make_ai_with_players("easy",2,4,2)
		-- create players
		create player1.make (1,1)
		create player2.make (2,2)
		create player3.make (3,1)
		create player4.make (4,2)
		-- set position
		player3.set_player_posistion (1)
		player4.set_player_posistion (2)
		player1.set_player_posistion (3)
		player2.set_player_posistion (4)

		create players.make_filled (Void, 0, 3)
		players[0] := player1
		players[1] := player2
		players[2] := player3
		players[3] := player4
		position := ai.position_in_the_round(1,players)
		worked := (position = 3)
		assert ("mark_a_card ok", worked)
	end

feature -- 	id_player_for_position

	test_id_player_for_position
	note
		testing: "covers/{TR_AI}.id_player_for_position"
		testing: "user/TR"
	local
		player1,player2,player3,player4: TR_PLAYER
		players: ARRAY[TR_PLAYER]
		id_player: INTEGER
		worked: BOOLEAN
	do
		create ai.make_ai_with_players("easy",2,4,2)
		-- create players
		create player1.make (1,1)
		create player2.make (2,2)
		create player3.make (3,1)
		create player4.make (4,2)
		-- set position
		player3.set_player_posistion (1)
		player4.set_player_posistion (2)
		player1.set_player_posistion (3)
		player2.set_player_posistion (4)

		create players.make_filled (Void, 0, 3)
		players[0] := player1
		players[1] := player2
		players[2] := player3
		players[3] := player4
		id_player := ai.id_player_for_position(2,players)
		worked := (id_player = 4)
		assert ("mark_a_card ok", worked)
	end

feature -- play card easy

	test_play_card_easy
	note
		testing: "covers/{TR_AI}.play_card_easy"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER
		card_player : ARRAY[TR_CARD]
		played_cards : ARRAY[BOOLEAN]
		game_state : TR_LOGIC
		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		-- create players
		print("Creating the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		create players.make_filled (Void, 0, 3)
		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_current_game_state.get_all_players.at (i)
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (4)
		players.at (1).set_player_posistion (1)
		players.at (2).set_player_posistion (2)
		players.at (3).set_player_posistion (3)

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 12)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 11)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("clubs", 12)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 1)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("cups",5)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id (id_player)
		game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_play (id_player).out + "%N")

		-- create the ai
		print("Creating AI easy with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("easy",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))

		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		played_cards := ai.played_cards_a

		print("Making the first AI player play %N")
		card_played := ai.play_card_easy (id_player,card_player, played_cards, game_state)
		print("Expecting 11 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")

		worked := card_played.get_card_value = 11 AND card_played.get_card_type.is_equal ("clubs")
		assert ("play_card_easy ok", worked)
	end


	test_play_card_easy2
	note
		testing: "covers/{TR_AI}.play_card_easy"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER
		card_player : ARRAY[TR_CARD]
		played_cards : ARRAY[BOOLEAN]
		game_state : TR_LOGIC
		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		-- create players
		print("Creating the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		create players.make_filled (Void, 0, 3)
		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_current_game_state.get_all_players.at (i)
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (1)
		players.at (1).set_player_posistion (2)
		players.at (2).set_player_posistion (3)
		players.at (3).set_player_posistion (4)

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 12)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 11)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 11)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("clubs", 12)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 1)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("cups",5)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id(id_player)
		game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_play (id_player).out + "%N")

		-- create the ai
		print("Creating AI easy with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("easy",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))

		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		played_cards := ai.played_cards_a

		print("Play for the first player %N")
		game_state.play_card (players.at (id_player -2).get_player_cards.at (0).deep_twin, players.at (id_player-2))

		print("Making the first AI player play %N")
		card_played := ai.play_card_easy (id_player,card_player, played_cards, game_state)
		print("Expecting 1 golds. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")
		worked := card_played.get_card_value = 1 AND card_played.get_card_type.is_equal ("golds")
		assert ("play_card_easy ok", worked)
	end


	test_play_card_easy3
	note
		testing: "covers/{TR_AI}.play_card_easy"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER
		card_player : ARRAY[TR_CARD]
		played_cards : ARRAY[BOOLEAN]
		game_state : TR_LOGIC
		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		-- create players
		print("Creating the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		create players.make_filled (Void, 0, 3)
		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_current_game_state.get_all_players.at (i)
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (4)
		players.at (1).set_player_posistion (1)
		players.at (2).set_player_posistion (2)
		players.at (3).set_player_posistion (3)

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 12)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 11)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("clubs", 12)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 1)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("cups",1)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id(id_player)
		game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_play (id_player).out + "%N")

		-- create the ai
		print("Creating AI easy with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("easy",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))

		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_b
		played_cards := ai.played_cards_b
		print_player_cards(players.at (id_player-1))
		print_player_cards(players.at (id_team_mate-1))
		print("Play for the first player %N")
		game_state.play_card (players.at (id_player-1).get_player_cards.at (1).deep_twin, players.at (id_player-1))

		print("Play for the second player %N")
		game_state.play_card (players.at (id_player).get_player_cards.at (2).deep_twin, players.at (id_player))

		print("Making the first AI player play %N")
		card_played := ai.play_card_easy (id_team_mate,card_player, played_cards, game_state)
		print("Expecting 1  cups. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")

		worked := card_played.get_card_value = 1 AND card_played.get_card_type.is_equal ("cups")
		assert ("play_card_easy ok", worked)
	end

test_play_card_easy4
	note
		testing: "covers/{TR_AI}.play_card_easy"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER
		card_player : ARRAY[TR_CARD]
		played_cards : ARRAY[BOOLEAN]
		game_state : TR_LOGIC
		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		-- create players
		print("Creating the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		create players.make_filled (Void, 0, 3)
		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_current_game_state.get_all_players.at (i)
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (4)
		players.at (1).set_player_posistion (1)
		players.at (2).set_player_posistion (2)
		players.at (3).set_player_posistion (3)

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 12)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 11)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("clubs", 10)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 1)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("cups",1)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id(id_player)
		game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_play (id_player).out + "%N")

		-- create the ai
		print("Creating AI easy with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("easy",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))

		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_b
		played_cards := ai.played_cards_b
		print_player_cards(players.at (id_player-1))
		print_player_cards(players.at (id_team_mate-1))
		print("Play for the first player %N")
		game_state.play_card (players.at (id_player-1).get_player_cards.at (1).deep_twin, players.at (id_player-1))

		print("Play for the second player %N")
		game_state.play_card (players.at (id_player).get_player_cards.at (2).deep_twin, players.at (id_player))

		print("Making the first AI player play %N")
		card_played := ai.play_card_easy (id_team_mate,card_player, played_cards, game_state)
		print("Expecting 7 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")

		worked := card_played.get_card_value = 7 AND card_played.get_card_type.is_equal ("cups")
		assert ("play_card_easy ok", worked)
	end


--feature -- play card test difficult

	prepare_game_state_and_players_round_1(game_state : TR_LOGIC; players: ARRAY[TR_PLAYER])
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		j : INTEGER


		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create players
		print("Setting the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_current_game_state.get_all_players.at (i)
			i := i + 1
		end
		from
			i := players.lower
		until
			i > players.upper
		loop
			print(players.at (i).get_player_name)
			print(" id : " + players.at(i).get_player_id.out)
			print(" team : " + players.at(i).get_player_team_id.out + "%N")
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (4)
		players.at (1).set_player_posistion (1)
		players.at (2).set_player_posistion (2)
		players.at (3).set_player_posistion (3)
		print(players.at (0).get_player_name + "'s position in the round is :" + players.at (0).get_player_posistion.out + "%N")
		print(players.at (1).get_player_name + "'s position in the round is :" + players.at (1).get_player_posistion.out + "%N")
		print(players.at (2).get_player_name + "'s position in the round is :" + players.at (2).get_player_posistion.out + "%N")
		print(players.at (3).get_player_name + "'s position in the round is :" + players.at (3).get_player_posistion.out + "%N")

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 12)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 11)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("swords", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("clubs", 12)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 1)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("swords",5)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)


		from
			i := players.lower
		until
			i > players.upper
		loop
			print_player_cards(players.at (i))
			i := i + 1
		end

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id (id_player)
		game_state.get_current_game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_play (id_player).out + "%N")

	end


	print_player_cards(player : TR_PLAYER)
	local
		j : INTEGER
	do
		print("Player : " + player.get_player_name)
		print(" cards : %N ")
		from
			j := player.get_player_cards.lower
		until
			j > player.get_player_cards.upper
		loop
			print("%T -> " + player.get_player_cards.at (j).get_card_value.out + " of " + player.get_player_cards.at (j).get_card_type + "%N")
			j := j + 1
		end
	end

	test_play_card_difficult_1_round_1_player_1
	note
		testing: "covers/{TR_AI}.play_card_difficult"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]

		i : INTEGER


		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		print("Creating players : %N")
		create players.make_filled (Void, 0, 3)

		print("Preparing game_state_and_players : %N")
		prepare_game_state_and_players_round_1(game_state, players)

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))


		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b
		print("Cards of AI player -> %N")
		from
			i := card_player.lower
		until
			i > card_player.upper
		loop
			print("%T"+card_player.at (i).get_card_value.out + " of type ")
			print(" of type " + card_player.at (i).get_card_type + "%N")
			i := i + 1
		end
		print("Cards of AI player team mate -> %N")
		from
			i := card_player.lower
		until
			i > card_player.upper
		loop
			print("%T"+card_team_mate.at (i).get_card_value.out + " of type ")
			print(" of type " + card_team_mate.at (i).get_card_type + "%N")
			i := i + 1
		end



		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		print("Expecting 11 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")


		worked := card_played.get_card_value = 11 AND card_played.get_card_type.is_equal ("clubs")

		assert ("test of play_card_difficult ok", worked)
	end


	test_play_card_difficult_2_round_1_player_1
	note
		testing: "covers/{TR_AI}.play_card_difficult"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]

		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		print("Creating players : %N")
		create players.make_filled (Void, 0, 3)

		print("Preparing game_state_and_players : %N")
		prepare_game_state_and_players_round_1(game_state, players)

		print("Changing a bit the cards so the first AI player has the best card of the two %N")
		card_played := players.at (id_player - 1).get_player_cards.at (0)
		players.at (id_player - 1).get_player_cards.at (0) := players.at (id_team_mate-1).get_player_cards.at (0)
		players.at (id_team_mate-1).get_player_cards.at (0) := card_played
		card_played := Void
		print_player_cards(players.at (id_player - 1))
		print_player_cards(players.at (id_team_mate - 1))

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))


		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		print("Expecting 1 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")


		worked := card_played.get_card_value = 1 AND card_played.get_card_type.is_equal ("clubs")

		assert ("test of play_card_difficult ok", worked)
	end


	test_play_card_difficult_3_round_1_player_1
	note
		testing: "covers/{TR_AI}.play_card_difficult"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]

		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		print("Creating players : %N")
		create players.make_filled (Void, 0, 3)

		print("Preparing game_state_and_players : %N")
		prepare_game_state_and_players_round_1(game_state, players)

		print("Changing a bit the cards so the first AI player has the best card of the two but nothing better than a two %N")
		players.at (id_player - 1).get_player_cards.at (0).make ("swords", 6)
		players.at (id_team_mate-1).get_player_cards.at (0).make ("cups", 11)
		print_player_cards(players.at (id_player - 1))
		print_player_cards(players.at (id_team_mate - 1))

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))


		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		print("Expecting 6 swords. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")


		worked := card_played.get_card_value = 6 AND card_played.get_card_type.is_equal ("swords")

		assert ("test of play_card_difficult ok", worked)
	end


	test_play_card_difficult_1_round_1_player_3
	note
		testing: "covers/{TR_AI}.play_card_difficult"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		print("Creating players : %N")
		create players.make_filled (Void, 0, 3)

		print("Preparing game_state_and_players : %N")
		prepare_game_state_and_players_round_1(game_state, players)

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))


		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		print("Expecting 11 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")

		print("Changing the game state %N")
		game_state.play_card (card_played, players.at (id_player-1))

		print("Play for the second player %N")
		create card_played.make (players.at (id_player+1 -1).get_player_cards.at (0).get_card_type, players.at (id_player+1 -1).get_player_cards.at (0).get_card_value)
		game_state.play_card (card_played, players.at (id_player+1 -1))

		print("Making the second AI player play %N")
		card_played := ai.play_card_difficult (id_team_mate,id_player,card_team_mate,card_player,team_mate_played_cards, played_cards, game_state)
		print("Expecting 1 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")


		worked := card_played.get_card_value = 1 AND card_played.get_card_type.is_equal ("clubs")

		assert ("test of play_card_difficult ok", worked)
	end


	test_play_card_difficult_2_round_1_player_3
	note
		testing: "covers/{TR_AI}.play_card_difficult"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]


		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		print("Creating players : %N")
		create players.make_filled (Void, 0, 3)

		print("Preparing game_state_and_players : %N")
		prepare_game_state_and_players_round_1(game_state, players)

		print("Changing a bit the cards so the second AI player doesn't have a better card than the first two %N")
		players.at (id_team_mate-1).get_player_cards.at (0).make ("cups", 3)
		print_player_cards(players.at (id_team_mate - 1))

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))


		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		print("Expecting 11 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")

		print("Changing the game state because we played a card %N")
		game_state.play_card (card_played, players.at (id_player-1))


		one_card := players.at (id_player+1 -1).get_player_cards.at (0)
		create card_played.make (one_card.get_card_type, one_card.get_card_value)
		print("Play for the second player the " + card_played.get_card_value.out + " of type " + card_played.get_card_type + "%N")
		game_state.play_card (card_played, players.at (id_player+1 -1))

		print("Making the second AI player play %N")
		card_played := ai.play_card_difficult (id_team_mate,id_player,card_team_mate,card_player,team_mate_played_cards, played_cards, game_state)
		print("Expecting 5 swords. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")
		print("Play for the third player the " + card_played.get_card_value.out + " of type " + card_played.get_card_type + "%N")
		game_state.play_card (card_played, players.at (id_team_mate-1))

		worked := card_played.get_card_value = 5 AND card_played.get_card_type.is_equal ("swords")

		assert ("test of play_card_difficult ok", worked)
	end

	test_play_card_difficult_3_round_1_player_3
	note
		testing: "covers/{TR_AI}.play_card_difficult"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]


		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		print("Creating players : %N")
		create players.make_filled (Void, 0, 3)

		print("Preparing game_state_and_players : %N")
		prepare_game_state_and_players_round_1(game_state, players)

		print("Changing a bit the cards so the second AI player doesn't have a better card than the first two %N")
		players.at (id_team_mate-1).get_player_cards.at (0).make ("clubs", 3)
		players.at (id_player+1-1).get_player_cards.at (0).make ("golds", 2)
		print_player_cards(players.at (id_team_mate - 1))
		print_player_cards(players.at (id_player+1 - 1))

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))


		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		print("Expecting 11 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")

		print("Changing the game state because we played a card %N")
		game_state.play_card (card_played, players.at (id_player-1))


		one_card := players.at (id_player+1 -1).get_player_cards.at (0)
		create card_played.make (one_card.get_card_type, one_card.get_card_value)
		print("Play for the second player the " + card_played.get_card_value.out + " of type " + card_played.get_card_type + "%N")
		game_state.play_card (card_played, players.at (id_player+1 -1))

		print("Making the second AI player play %N")
		card_played := ai.play_card_difficult (id_team_mate,id_player,card_team_mate,card_player,team_mate_played_cards, played_cards, game_state)
		print("Expecting 3 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")
		print("Play for the third player the " + card_played.get_card_value.out + " of type " + card_played.get_card_type + "%N")
		game_state.play_card (card_played, players.at (id_team_mate-1))

		worked := card_played.get_card_value = 3 AND card_played.get_card_type.is_equal ("clubs")

		assert ("test of play_card_difficult ok", worked)
	end

	test_play_card_difficult_1_round_1_player_2
	note
		testing: "covers/{TR_AI}.play_card_difficult"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]


		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		print("Creating players : %N")
		create players.make_filled (Void, 0, 3)

		print("Preparing game_state_and_players : %N")
		prepare_game_state_and_players_round_1(game_state, players)

		print("Changing players positions in the round so that the AI is now the 2 player: %N")
		players.at (0).set_player_posistion (1)
		players.at (1).set_player_posistion (2)
		players.at (2).set_player_posistion (3)
		players.at (3).set_player_posistion (4)
		print(players.at (0).get_player_name + "'s position in the round is :" + players.at (0).get_player_posistion.out + "%N")
		print(players.at (1).get_player_name + "'s position in the round is :" + players.at (1).get_player_posistion.out + "%N")
		print(players.at (2).get_player_name + "'s position in the round is :" + players.at (2).get_player_posistion.out + "%N")
		print(players.at (3).get_player_name + "'s position in the round is :" + players.at (3).get_player_posistion.out + "%N")

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))

		one_card := players.at (id_player-1 -1).get_player_cards.at (0)
		create card_played.make (one_card.get_card_type, one_card.get_card_value)
		print("Play for the first player the " + card_played.get_card_value.out + " of type " + card_played.get_card_type + "%N")
		game_state.play_card (card_played, players.at (id_player-1 -1))

		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		print("Expecting 11 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")

		print("Changing the game state because we played a card %N")
		game_state.play_card (card_played, players.at (id_player-1))

		worked := card_played.get_card_value = 11 AND card_played.get_card_type.is_equal ("clubs")

		assert ("test of play_card_difficult ok", worked)
	end

	test_play_card_difficult_2_round_1_player_2
	note
		testing: "covers/{TR_AI}.play_card_difficult"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]


		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		print("Creating players : %N")
		create players.make_filled (Void, 0, 3)

		print("Preparing game_state_and_players : %N")
		prepare_game_state_and_players_round_1(game_state, players)

		print("Changing players positions in the round so that the AI is now the 2 player: %N")
		players.at (0).set_player_posistion (1)
		players.at (1).set_player_posistion (2)
		players.at (2).set_player_posistion (3)
		players.at (3).set_player_posistion (4)
		print(players.at (0).get_player_name + "'s position in the round is :" + players.at (0).get_player_posistion.out + "%N")
		print(players.at (1).get_player_name + "'s position in the round is :" + players.at (1).get_player_posistion.out + "%N")
		print(players.at (2).get_player_name + "'s position in the round is :" + players.at (2).get_player_posistion.out + "%N")
		print(players.at (3).get_player_name + "'s position in the round is :" + players.at (3).get_player_posistion.out + "%N")

		print("Changing AI players' cards for the 1 AI player to have the best card : %N")
		players.at (3).get_player_cards.at (0).make ("golds", 12)

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))

		one_card := players.at (id_player-1 -1).get_player_cards.at (0)
		create card_played.make (one_card.get_card_type, one_card.get_card_value)
		print("Play for the first player the " + card_played.get_card_value.out + " of type " + card_played.get_card_type + "%N")
		game_state.play_card (card_played, players.at (id_player-1 -1))

		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		print("Expecting 3 golds. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")

		print("Changing the game state because we played a card %N")
		game_state.play_card (card_played, players.at (id_player-1))

		worked := card_played.get_card_value = 3 AND card_played.get_card_type.is_equal ("golds")

		assert ("test of play_card_difficult ok", worked)
	end

feature -- test accept_envido
	test_accept_envido
	note
		testing: "covers/{TR_AI}.test_accept_envido"
		testing: "user/TR"
	local
		worked_well : BOOLEAN
	do
		create ai.make_ai_with_players("difficult",2,4,2)
		worked_well := ai.accept_envido(25,BC.envido,20)
		assert ("test_accept_envido ok", worked_well)
	end

	test_accept_envido2
	note
		testing: "covers/{TR_AI}.test_accept_envido"
		testing: "user/TR"
	local
		worked_well : BOOLEAN
	do
		create ai.make_ai_with_players("difficult",2,4,2)
		worked_well := ai.accept_envido(30,BC.real_envido,20)
		assert ("test_accept_envido ok", worked_well)
	end

	test_accept_envido3
	note
		testing: "covers/{TR_AI}.test_accept_envido"
		testing: "user/TR"
	local
		worked_well : BOOLEAN
	do
		create ai.make_ai_with_players("difficult",2,4,2)
		worked_well := ai.accept_envido(31,BC.falta_envido,20)
		assert ("test_accept_envido ok", worked_well)
	end

	test_accept_envido4
	note
		testing: "covers/{TR_AI}.test_accept_envido"
		testing: "user/TR"
	local
		worked_well : BOOLEAN
	do
		create ai.make_ai_with_players("difficult",2,4,2)
		worked_well := NOT ai.accept_envido(24,BC.envido,20)
		assert ("test_accept_envido ok", worked_well)
	end

	test_accept_envido5
	note
		testing: "covers/{TR_AI}.test_accept_envido"
		testing: "user/TR"
	local
		worked_well : BOOLEAN
	do
		create ai.make_ai_with_players("difficult",2,4,2)
		worked_well := NOT ai.accept_envido(29,BC.real_envido,20)
		assert ("test_accept_envido ok", worked_well)
	end

	test_accept_envido6
	note
		testing: "covers/{TR_AI}.test_accept_envido"
		testing: "user/TR"
	local
		worked_well : BOOLEAN
	do
		create ai.make_ai_with_players("difficult",2,4,2)
		worked_well := NOT ai.accept_envido(30,BC.falta_envido,20)
		assert ("test_accept_envido ok", worked_well)
	end

	test_accept_envido7
	note
		testing: "covers/{TR_AI}.test_accept_envido"
		testing: "user/TR"
	local
		worked_well : BOOLEAN
	do
		create ai.make_ai_with_players("difficult",2,4,2)
		worked_well := NOT ai.accept_envido(32,BC.falta_envido,15)
		assert ("test_accept_envido ok", worked_well)
	end

feature -- send_envido

	test_send_envido
	note
		testing: "covers/{TR_AI}.send_envido"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER
		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]
		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]
		game_state : TR_LOGIC
		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		bet : STRING
		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		-- create players
		print("Creating the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		create players.make_filled (Void, 0, 3)
		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_current_game_state.get_all_players.at (i)
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (4)
		players.at (1).set_player_posistion (1)
		players.at (2).set_player_posistion (2)
		players.at (3).set_player_posistion (3)

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 12)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 11)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("clubs", 12)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 1)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("cups",5)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id(id_player)
		game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_answer_a_bet (id_player).out + "%N")

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))

		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		print("Expecting 11 clubs. Card played by the first AI player " + card_played.get_card_value.out + " of " + card_played.get_card_type + " %N")

		print("Changing the game state %N")
		game_state.play_card (card_played, players.at (id_player-1))

		print("Play for the second player %N")
		game_state.play_card (players.at (id_player+1 -1).get_player_cards.at (0), players.at (id_player+1 -1))

		print("Making the second AI player play %N")
		bet :=ai.send_envido (players[id_team_mate-1], ai.envido_points_b, 0, game_state)
		worked := (bet = BC.envido)

		assert ("send_envido ok", worked)
	end

	test_send_envido2
	note
		testing: "covers/{TR_AI}.send_envido"
		testing: "user/TR"
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER
		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]
		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]
		game_state : TR_LOGIC
		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		bet : STRING
		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		-- create players
		print("Creating the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		create players.make_filled (Void, 0, 3)
		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_current_game_state.get_all_players.at (i)
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (4)
		players.at (1).set_player_posistion (1)
		players.at (2).set_player_posistion (2)
		players.at (3).set_player_posistion (3)

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 7)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 11)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("clubs", 12)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 1)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("cups",5)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id (id_player)
		game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_play (id_player).out + "%N")

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))

		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		bet :=ai.send_envido (players[id_player-1], ai.envido_points_a, 0, game_state)
		worked := NOT (bet = BC.envido)

		assert ("send_envido ok", worked)
	end

feature -- test bet_available and team_bet_available

	test_bet_available
	local
		worked_well : BOOLEAN
		cards : ARRAY[TR_CARD]
		card1, card2, card3 : TR_CARD
	do
		worked_well := false
		create ai.make_ai_with_players("difficult",2,4,2)
		create cards.make_filled (void,0,2)
     	create card1.make ("swords", 1)
		create card2.make ("golds", 4)
		create card3.make ("golds", 5)
		cards[0] := card1
		cards[1] := card2
		cards[2] := card3
		print (worked_well.out + "%N")
		worked_well := ai.bet_available (cards, 8)
		print (worked_well.out + "%N")
		assert ("team_bet_available ok", worked_well)
	end

	test_bet_available_2
	local
		worked_well : BOOLEAN
		cards : ARRAY[TR_CARD]
		card1, card2, card3 : TR_CARD
	do
		worked_well := false
		create ai.make_ai_with_players("difficult",2,4,2)
		create cards.make_filled (void,0,2)
     	create card1.make ("swords", 2)
		create card2.make ("golds", 3)
		create card3.make ("clubs", 3)
		cards[0] := card1
		cards[1] := card2
		cards[2] := card3
		print (worked_well.out + "%N")
		worked_well :=  ai.bet_available (cards, 8)
		print (worked_well.out + "%N")
		assert ("team_bet_available ok", worked_well)
	end

	test_bet_available_3
	local
		worked_well : BOOLEAN
		cards : ARRAY[TR_CARD]
		card1, card2, card3 : TR_CARD
	do
		worked_well := false
		create ai.make_ai_with_players("difficult",2,4,2)
		create cards.make_filled (void,0,2)
     	create card1.make ("swords", 4)
		create card2.make ("golds", 5)
		create card3.make ("golds", 4)
		cards[0] := card1
		cards[1] := card2
		cards[2] := card3
		print (worked_well.out + "%N")
		worked_well := not ai.bet_available (cards, 8)
		print (worked_well.out + "%N")
		assert ("team_bet_available ok", worked_well)
	end



	test_team_bet_available
	local
		worked_well : BOOLEAN
		cards1, cards2 : ARRAY[TR_CARD]
		card1, card2, card3, card4, card5, card6 : TR_CARD
	do
		worked_well := false
		create ai.make_ai_with_players("difficult",2,4,2)
		create cards1.make_filled (void,0,2)
		create cards2.make_filled (void,0,2)
     	create card1.make ("swords", 1)
		create card2.make ("golds", 4)
		create card3.make ("golds", 5)
		create card4.make ("clubs", 1)
		create card5.make ("golds", 2)
		create card6.make ("swords", 7)
		cards1[0] := card1
		cards1[1] := card2
		cards1[2] := card3
		cards2[0] := card4
		cards2[1] := card5
		cards2[2] := card6
		print (worked_well.out + "%N")
		worked_well := ai.team_bet_available(cards1,cards2,10)
		print (worked_well.out + "%N")
		assert ("team_bet_available ok", worked_well)
	end

	test_team_bet_available_2
	local
		worked_well : BOOLEAN
		cards1, cards2 : ARRAY[TR_CARD]
		card1, card2, card3, card4, card5, card6 : TR_CARD
	do
		worked_well := false
		create ai.make_ai_with_players("difficult",2,4,2)
		create cards1.make_filled (void,0,2)
		create cards2.make_filled (void,0,2)
     	create card1.make ("golds", 1)
		create card2.make ("golds", 4)
		create card3.make ("golds", 5)
		create card4.make ("cups", 1)
		create card5.make ("golds", 2)
		create card6.make ("cups", 7)
		cards1[0] := card1
		cards1[1] := card2
		cards1[2] := card3
		cards2[0] := card4
		cards2[1] := card5
		cards2[2] := card6
		print (worked_well.out + "%N")
		worked_well := not ai.team_bet_available(cards1,cards2,10)
		print (worked_well.out + "%N")
		assert ("team_bet_available ok", worked_well)
	end


	test_this_card_play
	local
		worked_well : BOOLEAN
		cards : ARRAY[TR_CARD]
		card1, card2, card3 : TR_CARD
	do
		worked_well := false
		create ai.make_ai_with_players("difficult",2,4,2)
		create cards.make_filled (void, 0, 2)
		create card1.make ("swords", 1)
		create card2.make ("swords", 3)
		create card3.make ("swords", 4)
		print ("everything is ok" + "%N")
		cards[0] := card1
		cards[1] := card2
		cards[2] := card3
		print ( "card1 : " + cards.at (0).get_card_weight_truco.out  + "%N")
		print ( "card2 : " + cards.at (1).get_card_weight_truco.out  + "%N")
		print ( "card3 : " + cards.at (2).get_card_weight_truco.out  + "%N")
		print (worked_well.out + "%N")
		worked_well := ai.this_card_played (13, cards)
		print (worked_well.out + "%N")
		assert ("this_card_play ok", worked_well)
	end

	test_this_card_play_2
	local
		worked_well : BOOLEAN
		cards_on_the_table : ARRAY[TR_CARD]
		card1, card2, card3 : TR_CARD
	do
		worked_well := false
		create ai.make_ai_with_players("difficult",2,4,2)
		create cards_on_the_table.make_filled (void, 0, 2)
		create card1.make ("swords", 2)
		create card2.make ("swords", 3)
		create card3.make ("swords", 4)
		print ("everything is ok" + "%N")
		cards_on_the_table[0] := card1
		cards_on_the_table[1] := card2
		cards_on_the_table[2] := card3
		print (worked_well.out + "%N")
		worked_well := not ai.this_card_played (13, cards_on_the_table)
		print (worked_well.out + "%N")
		assert ("this_card_play ok", worked_well)
	end

	test_accept_truco_dif
	local
		bet : STRING
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		j : INTEGER


		card_played : TR_CARD
		worked: BOOLEAN
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		-- create players
		print("Creating the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		create players.make_filled (Void, 0, 3)
		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_current_game_state.get_all_players.at (i)
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (4)
		players.at (1).set_player_posistion (1)
		players.at (2).set_player_posistion (2)
		players.at (3).set_player_posistion (3)

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 12)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 11)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("swords", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("clubs", 12)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("swords",5)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id (id_player)
		game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_play (id_player).out + "%N")

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))


		-- getting all information we need and deciding to accept or not a bet
		print ("Initializing the bet %N")
		bet := "Retruco"

	-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b



		worked := ai.accept_truco_dif (bet, game_state, card_player, played_cards, card_team_mate,team_mate_played_cards )

		assert ("accept_truco_diff ok", worked)
	end


	test_send_truco_difficil
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		j : INTEGER


		card_played : TR_CARD
		worked: BOOLEAN
		resultat : STRING
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		-- create players
		print("Creating the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		create players.make_filled (Void, 0, 3)
		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_current_game_state.get_all_players.at (i)
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (4)
		players.at (1).set_player_posistion (1)
		players.at (2).set_player_posistion (2)
		players.at (3).set_player_posistion (3)

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 12)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("swords", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("swords", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 1)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 7)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)



		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("swords",5)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id (id_player)
		game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_play (id_player).out + "%N")

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))


		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		create resultat.make_empty

		resultat := ai.send_truco_difficulty (game_state, players.at (id_player-1), card_player , played_cards, players.at (id_team_mate-1), card_team_mate,team_mate_played_cards)
		print("le resultat est : " + resultat)
		worked := resultat.is_equal ("truco") or resultat.is_equal("")
		assert ("test of play_card_difficult ok", worked)
	end


	test_send_truco_difficil_2
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		j : INTEGER


		card_played : TR_CARD
		worked: BOOLEAN
		resultat : STRING
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		-- create players
		print("Creating the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		create players.make_filled (Void, 0, 3)
		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_current_game_state.get_all_players.at (i)
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (4)
		players.at (1).set_player_posistion (1)
		players.at (2).set_player_posistion (2)
		players.at (3).set_player_posistion (3)

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 12)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("swords", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("swords", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 1)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 7)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)



		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("swords",5)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id (id_player)
		game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_play (id_player).out + "%N")

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))


		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		create resultat.make_empty
		game_state.set_round_number (2)

		resultat := ai.send_truco_difficulty (game_state, players.at (id_player-1), card_player , played_cards, players.at (id_team_mate-1), card_team_mate,team_mate_played_cards)
		print("le resultat est : " + resultat)
		worked := resultat.is_equal ("truco")
		assert ("test of play_card_difficult ok", worked)
	end

test_send_truco_difficil_3
	local
		id_player: INTEGER
		id_team_mate: INTEGER
		team : INTEGER

		card_player : ARRAY[TR_CARD]
		card_team_mate : ARRAY[TR_CARD]

		played_cards : ARRAY[BOOLEAN]
		team_mate_played_cards : ARRAY[BOOLEAN]

		game_state : TR_LOGIC

		players: ARRAY[TR_PLAYER]
		one_card : TR_CARD
		one_player_cards : ARRAY[TR_CARD]

		i : INTEGER
		j : INTEGER


		card_played : TR_CARD
		worked: BOOLEAN
		resultat : STRING
	do
		-- create players ids
		id_player := 2
		id_team_mate := 4
		-- create players team
		team := 2

		-- create the logic
		print("Creating game state : %N")
		create game_state.make

		-- create players
		print("Creating the four players : %N")
		game_state.set_player_info ("Test1", 1, 1)
		game_state.set_player_info ("AI2", 2, 2)
		game_state.set_player_info ("Test3", 3, 1)
		game_state.set_player_info ("AI4", 4, 2)

		create players.make_filled (Void, 0, 3)
		from
			i := players.lower
		until
			i > players.upper
		loop
			players.at (i) := game_state.get_players.at (i)
			i := i + 1
		end

		print("Setting there positions in the round : %N")
		players.at (0).set_player_posistion (4)
		players.at (1).set_player_posistion (1)
		players.at (2).set_player_posistion (2)
		players.at (3).set_player_posistion (3)

		print("Dealing cards as we want : %N")
		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 5)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 12)
		one_player_cards.at (2) := one_card
		players.at (0).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("swords", 7)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 2)
		one_player_cards.at (1) := one_card
		create one_card.make ("swords", 1)
		one_player_cards.at (2) := one_card
		players.at (1).set_cards (one_player_cards)

		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("golds", 2)
		one_player_cards.at (0) := one_card
		create one_card.make ("clubs", 1)
		one_player_cards.at (1) := one_card
		create one_card.make ("golds", 7)
		one_player_cards.at (2) := one_card
		players.at (2).set_cards (one_player_cards)



		create one_player_cards.make_filled (Void, 0, 2)
		create one_card.make ("clubs", 3)
		one_player_cards.at (0) := one_card
		create one_card.make ("cups", 7)
		one_player_cards.at (1) := one_card
		create one_card.make ("swords",5)
		one_player_cards.at (2) := one_card
		players.at (3).set_cards (one_player_cards)

		-- setting the player to play
		print("Setting that the player who has to play is the AI2 and the round %N")
		game_state.get_current_game_state.set_the_player_turn_id (id_player)
		game_state.set_round_number (1)
		print("%T -> Need to play : " + game_state.get_current_game_state.do_i_have_to_play (id_player).out + "%N")

		-- create the ai
		print("Creating AI difficult with players : " + id_player.out + " and " + id_team_mate.out + " in team " + team.out + "%N")
		create ai.make_ai_with_players("difficult",id_player,id_team_mate,team)
		-- updating the hand
		print("And updating the hand of the AI players " + players.at (id_player-1).get_player_name + " and " + players.at (id_team_mate-1).get_player_name + "%N")
		ai.update_hand (players.at (id_player-1),players.at (id_team_mate-1))


		-- getting all information we need and playing a card in difficult mode
		print("Checking the cards of AI players one more time %N")
		card_player := ai.player_cards_a
		card_team_mate := ai.player_cards_b
		played_cards := ai.played_cards_a
		team_mate_played_cards := ai.played_cards_b

		create resultat.make_empty
		game_state.set_round_number (2)
		game_state.send_truco (1)
		print("Current_bet : " + game_state.get_current_bet + "%N")
		game_state.send_accept (2)
		print("Current_bet : " + game_state.get_current_bet + "%N")
		game_state.play_card (players.at (2).get_cards_played.at (1),players.at (2))
		print("Current_bet : " + game_state.get_current_bet + "%N")
		resultat := ai.send_truco_difficulty (game_state, players.at (id_player-1), card_player , played_cards, players.at (id_team_mate-1), card_team_mate,team_mate_played_cards)
		print("le resultat est : " + resultat)
		worked := resultat.is_equal ("truco")
		assert ("test of play_card_difficult ok", false)
	end



	test_prepare_the_table
	local
		worked : BOOLEAN
		cards1, cards2,array_result : ARRAY[TR_CARD]
		card1, card2, card3, card4, card5, card6 : TR_CARD
	do
		worked := false
		create ai.make_ai_with_players("difficult",2,4,2)
		create cards1.make_filled (void,0,2)
		create cards2.make_filled (void,0,2)
		create array_result.make_filled (void, 0, 5)
     	create card1.make ("golds", 1)
		create card2.make ("golds", 4)
		create card3.make ("golds", 5)
		create card4.make ("cups", 1)
		create card5.make ("golds", 2)
		create card6.make ("cups", 7)
		cards1[0] := card1
		cards1[1] := card2
		cards1[2] := card3
		cards2[0] := card4
		cards2[1] := card5
		cards2[2] := card6
		array_result := ai.prepare_the_table (cards1, cards2)
		print( array_result.at (0).get_card_value.out + "%N" )
		print( array_result.at (1).get_card_value.out + "%N" )
		print( array_result.at (2).get_card_value.out + "%N" )
		print( array_result.at (3).get_card_value.out + "%N" )
		print( array_result.at (4).get_card_value.out + "%N" )
		print( array_result.at (5).get_card_value.out + "%N" )
		worked := array_result.at (0).get_card_value = 1 and array_result.at (1).get_card_value = 4 and array_result.at (2).get_card_value = 5 and array_result.at (3).get_card_value = 1 and array_result.at (4).get_card_value = 2 and array_result.at (5).get_card_value = 7

		assert ("prepare_the_table ok", worked)
	end

feature --test_play_the_highest_cards

	play_the_highest_cards_1
	note
		testing: "covers/{TR_AI}.play_the_highest_cards_1"
		testing: "user/TR"
	local
		card_1, card_2, card_3, card_4 : TR_CARD
		table_cards : ARRAY[TR_CARD]
		worked_well : BOOLEAN
	do

		--create make
		create ai.make_ai_with_players("easy",2,4,2)

		--create array table
		create table_cards.make_filled (void, 0, 3)

		--create cards table
		create card_1.make ("clubs",1)
		create card_2.make ("clubs",5)
		create card_3.make ("clubs",6)
		create card_4.make ("clubs",7)

		table_cards[0] := card_1
		table_cards[1] := card_2
		table_cards[2] := card_3
		table_cards[3] := card_4

		worked_well := ai.play_the_highest_cards (table_cards) = false
		assert("Ok", worked_well)
	end

	play_the_highest_cards_2
	note
		testing: "covers/{TR_AI}.play_the_highest_cards_2"
		testing: "user/TR"
	local
		card_1, card_2, card_3, card_4 : TR_CARD
		table_cards : ARRAY[TR_CARD]
		worked_well : BOOLEAN
	do

		--create make
		create ai.make_ai_with_players("easy",2,4,2)

		--create array table
		create table_cards.make_filled (void, 0, 3)

		--create cards table
		create card_1.make ("swords",1)
		create card_2.make ("swords",7)
		create card_3.make ("clubs",1)
		create card_4.make ("golds",7)

		table_cards[0] := card_1
		table_cards[1] := card_2
		table_cards[2] := card_3
		table_cards[3] := card_4

		worked_well := ai.play_the_highest_cards (table_cards)
		assert("Ok", worked_well)
	end

feature --test_played_some_or_none_cards

	test_played_some_or_none_cards_1
	note
		testing: "covers/{TR_AI}.test_played_some_or_none_cards_1"
		testing: "user/TR"
	local
		card_1, card_2, card_3, card_4 : TR_CARD
		table_cards : ARRAY[TR_CARD]
		worked_well : BOOLEAN
	do

		--create make
		create ai.make_ai_with_players("easy",2,4,2)

		--create array table
		create table_cards.make_filled (void, 0, 3)

		--create cards table
		create card_1.make ("clubs",1)
		create card_2.make ("clubs",5)
		create card_3.make ("clubs",6)
		create card_4.make ("clubs",7)

		table_cards[0] := card_1
		table_cards[1] := card_2
		table_cards[2] := card_3
		table_cards[3] := card_4

		worked_well := ai.played_some_or_none_cards (table_cards)
		assert("Ok", worked_well)
	end



	test_played_some_or_none_cards_2
	note
		testing: "covers/{TR_AI}.test_played_some_or_none_cards_2"
		testing: "user/TR"
	local
		card_1, card_2, card_3, card_4 : TR_CARD
		table_cards : ARRAY[TR_CARD]
		worked_well : BOOLEAN
	do

		--create make
		create ai.make_ai_with_players("easy",2,4,2)

		--create array table
		create table_cards.make_filled (void, 0, 3)

		--create cards table
		create card_1.make ("swords",1)
		create card_2.make ("swords",7)
		create card_3.make ("clubs",1)
		create card_4.make ("golds",7)

		table_cards[0] := card_1
		table_cards[1] := card_2
		table_cards[2] := card_3
		table_cards[3] := card_4

		worked_well := ai.played_some_or_none_cards (table_cards)
		assert("Ok", worked_well)
	end

	test_played_some_or_none_cards_3
	note
		testing: "covers/{TR_AI}.test_played_some_or_none_cards_3"
		testing: "user/TR"
	local
		card_1, card_2, card_3, card_4 : TR_CARD
		table_cards : ARRAY[TR_CARD]
		worked_well : BOOLEAN
	do

		--create make
		create ai.make_ai_with_players("easy",2,4,2)

		--create array table
		create table_cards.make_filled (void, 0, 3)

		--create cards table
		create card_1.make ("swords",5)
		create card_2.make ("swords",4)
		create card_3.make ("clubs",4)
		create card_4.make ("golds",4)

		table_cards[0] := card_1
		table_cards[1] := card_2
		table_cards[2] := card_3
		table_cards[3] := card_4

		worked_well := ai.played_some_or_none_cards (table_cards) = false
		assert("Ok", worked_well)
	end




end
