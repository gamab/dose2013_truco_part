note
	description: "Test for the class TR_PLAYER (from model)"
	author: "RioCuarto5: Matias Donatti"
	date: "12/11/2013"
	revision: "0.01"
	testing: "type/manual"


class
	TR_TEST_PLAYER

inherit
	EQA_TEST_SET
	redefine
		on_prepare
	end

feature {none}

	player:TR_PLAYER

	on_prepare
	do
		create player.make (1,1)
	end


feature -- Test update_score

	test_update_score_1
		-- Test if update_scored works well
		note
			testing: "covers/{TR_PLAYER}.update_score"
			testing: "user/TR"
		local
			score:INTEGER
		do

			player.set_player_team_score (4)
			score := player.get_player_team_score
			player.set_player_team_score (score+4)
			score := player.get_player_team_score
			assert ("update_score worked", score = 8)
		end

	test_update_score_2
		-- breaks when set with an invalid value
		note
			testing: "covers/{TR_PLAYER}.update_score"
			testing: "user/TR"
		local
			rescued : BOOLEAN
			passed : BOOLEAN
		do
			if not rescued then
				player.set_player_team_score (4)
				passed := True
			end
			assert ("update_score broke",  passed)
		rescue
			if (not rescued) then
				rescued := True
				retry
			end
		end

feature -- Test set_player_id

	test_set_player_id_1
		-- breaks when set with an invalid value
		note
			testing: "covers/{TR_PLAYER}.set_player_id"
			testing: "user/TR"
		local
			rescued : BOOLEAN
			passed : BOOLEAN
		do
			if not rescued then
				player.set_player_id (5)
				passed := True
			end
			assert ("set_player_id broke", passed)
		rescue
			if (not rescued) then
				rescued := True
				retry
			end
		end

feature -- Test set_player_team_id

	test_set_player_team_id_1
		-- breaks when set with an invalid value
		note
			testing: "covers/{TR_PLAYER}.set_player_team_id"
			testing: "user/TR"
		local
			rescued : BOOLEAN
			passed : BOOLEAN
		do
			if not rescued then
				player.set_player_team_id (3)
				passed := True
			end
			assert ("set_player_team_id broke", passed)
		rescue
			if (not rescued) then
				rescued := True
				retry
			end
		end

feature -- Test set_player_posistion

	test_set_player_posistion_1
		-- breaks when set with an invalid value
		note
			testing: "covers/{TR_PLAYER}.set_player_posistion"
			testing: "user/TR"
		local
			rescued : BOOLEAN
			passed : BOOLEAN
		do
			if not rescued then
				player.set_player_posistion (-1)
				passed := True
			end
			assert ("set_player_posistion broke", passed)
		rescue
			if (not rescued) then
				rescued := True
				retry
			end
		end

feature --Test set_cards

	test_set_cards_1
		-- breaks when set 4 cards
		note
			testing: "covers/{TR_PLAYER}.set_cards"
			testing: "user/TR"
		local
			card1,card2,card3,card4 : TR_CARD
			cards : ARRAY[TR_CARD]
			rescued,passed : BOOLEAN
		do
			if not rescued then
				create cards.make_empty
				create card1.make ("clubs",12)
				create card2.make ("clubs",1)
				create card3.make ("gold",7)
				create card4.make ("gold",1)
				cards.put (card1,1)
				cards.put (card2,2)
				cards.put (card3,3)
				cards.put (card4,4)
				player.set_cards (cards)
				passed := True
			end
			assert ("set_cards broke", not passed)
		rescue
			if (not rescued) then
				rescued := True
				retry
			end
		end

		test_set_cards_2
			-- breaks when set 2 cards equals
			note
				testing: "covers/{TR_PLAYER}.set_cards"
				testing: "user/TR"
			local
				card1,card2,card3 : TR_CARD
				cards : ARRAY[TR_CARD]
				rescued,passed : BOOLEAN
			do
				if not rescued then
					create cards.make_empty
					create card1.make ("clubs",12)
					create card2.make ("clubs",1)
					create card3.make ("clubs",12)
					cards.put (card1,1)
					cards.put (card2,2)
					cards.put (card3,3)
					player.set_cards (cards)
					passed := True
				end
				assert ("set_cards broke", not passed)
			rescue
				if (not rescued) then
					rescued := True
					retry
				end
			end

feature -- set_player_current_card

	set_player_current_card_1
		-- test if remove one card
		note
			testing: "covers/{TR_PLAYER}.set_player_current_card"
			testing: "user/TR"
		local
			card1,card2,card3 : TR_CARD
			cards,cards2 : ARRAY[TR_CARD]

		do
			create cards.make_filled (void, 0, 2)
			create cards2.make_empty
			create card1.make ("clubs",12)
			create card2.make ("clubs",1)
			create card3.make ("clubs",2)
			cards.put (card1,0)
			cards.put (card2,1)
			cards.put (card3,2)
			player.set_cards (cards)
			player.set_player_current_card (card2)
			cards2.copy (player.get_player_cards)
			assert ("set_player_current_card worked ", cards2.count=3)
		end
feature -- get_player_current_card

		get_player_current_card_1
			-- test if current_card is valid
			note
				testing: "covers/{TR_PLAYER}.get_player_current_card"
				testing: "user/TR"
			local
				card1,card2,card3,card4 : TR_CARD
				cards,cards2 : ARRAY[TR_CARD]
			do
				create cards.make_filled (void, 0, 2)
				create cards2.make_empty
				create card1.make ("clubs",12)
				create card2.make ("clubs",1)
				create card3.make ("clubs",2)
				cards.put (card1,0)
				cards.put (card2,1)
				cards.put (card3,2)
				player.set_cards (cards)
				player.set_player_current_card (card2)
				cards2.copy (player.get_player_cards)
				card4  := player.get_player_current_card
				assert ("get_player_current_card worked ", deep_equal(card2,card4))
			end


end
