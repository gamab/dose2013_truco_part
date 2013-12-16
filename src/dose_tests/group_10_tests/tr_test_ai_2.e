note
	description: "Summary description for {TR_TEST_AI_2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_TEST_AI_2
inherit
	TR_TEST_AI

feature -- usefull for tests


	round_check(gs : TR_LOGIC)
	do
		print("%N---------------%N")
		print("END ROUND CHECK%N")
		print("---------------%N%N")

		print("Is the round ended : " + gs.is_end_round.out + "%N")
		if gs.is_end_round then
			print("Going to next round ! %N")
			gs.end_round
			print("Player who won the round " + (gs.get_round_number - 1).out + " : " + gs.get_round[gs.get_round_number - 2].out + "%N")
		end
		print("Is there a winner of the hand : " + gs.is_there_a_winner_of_the_hand.out + "%N")
	end

feature -- example test
	test_play_card_difficult_1_round_2_player
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

		print("Changing players positions in the round so that the AI is now the 2 player: %N")
		players.at (0).set_player_posistion (1)
		players.at (1).set_player_posistion (2)
		players.at (2).set_player_posistion (3)
		players.at (3).set_player_posistion (4)
		print(players.at (0).get_player_name + "'s position in the round is :" + players.at (0).get_player_posistion.out + "%N")
		print(players.at (1).get_player_name + "'s position in the round is :" + players.at (1).get_player_posistion.out + "%N")
		print(players.at (2).get_player_name + "'s position in the round is :" + players.at (2).get_player_posistion.out + "%N")
		print(players.at (3).get_player_name + "'s position in the round is :" + players.at (3).get_player_posistion.out + "%N")
		game_state.get_current_game_state.set_the_player_turn_id (1)

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


		print("%N-------------%N")
		print("START PLAYING%N")
		print("-------------%N%N")

		print("-> ROUND " + game_state.get_round_number.out + "%N")

		print("-> Who has to play ? " + game_state.get_current_game_state.get_the_player_turn_id.out + " %N")

		card_played := players.at (0).get_player_cards[2]
		print("Making the first 'normal' player play : " +  card_played.out + "%N")
		game_state.play_card (card_played, players.at (0))

		print("-> Who has to play ? " + game_state.get_current_game_state.get_the_player_turn_id.out + " %N")

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		game_state.play_card (card_played, players.at (id_player-1))
		print("Expecting [11 clubs]. Card played by the first AI player " + card_played.out + " %N")

		card_played := players.at (2).get_player_cards[0]
		print("Making the second 'normal' player play : " +  card_played.out + "%N")
		game_state.play_card (card_played, players.at (2))

		print("Making the second AI player play %N")
		card_played := ai.play_card_difficult (id_team_mate, id_player,card_team_mate,card_player,team_mate_played_cards, played_cards, game_state)
		game_state.play_card (card_played, players.at (id_team_mate-1))
		print("Expecting [1 clubs]. Card played by the first AI player " + card_played.out + " %N")

		round_check(game_state)

		print("%N-------------%N")
		print("RESTART PLAYING%N")
		print("-------------%N%N")

		print("-> ROUND " + game_state.get_round_number.out + "%N")

		print("-> Who has to play ? " + game_state.get_current_game_state.get_the_player_turn_id.out + " %N")

		print("Making the second AI player play %N")
		card_played := ai.play_card_difficult (id_team_mate, id_player,card_team_mate,card_player,team_mate_played_cards, played_cards, game_state)
		game_state.play_card (card_played, players.at (id_team_mate-1))
		print("Expecting [7 cups]. Card played by the first AI player " + card_played.out + " %N")

		card_played := players.at (0).get_player_cards[0]
		print("Making the first 'normal' player play : " +  card_played.out + "%N")
		game_state.play_card (card_played, players.at (0))

		print("Making the first AI player play %N")
		card_played := ai.play_card_difficult (id_player, id_team_mate,card_player,card_team_mate,played_cards,team_mate_played_cards, game_state)
		game_state.play_card (card_played, players.at (id_player-1))
		print("Expecting [3 clubs]. Card played by the first AI player " + card_played.out + " %N")

		card_played := players.at (2).get_player_cards[2]
		print("Making the second 'normal' player play : " +  card_played.out + "%N")
		game_state.play_card (card_played, players.at (2))

		round_check(game_state)


		worked := card_played.get_card_value = 3 AND card_played.get_card_type.is_equal ("golds")

--		assert ("test of play_card_difficult ok", worked)
	end
end
