note
        description: " {TR_GAME_STATE} represent the game state to use for network ."
        author: "tariqsenosy"
        date: "10/11/2013"
        revision: "tariqsenosy"

class
        TR_GAME_STATE
inherit
        STORABLE
create
    make
feature{TR_LOGIC}
	rounds					:ARRAY[INTEGER]-- save the id of winners in every round
	the_deck_cards			:ARRAY[TR_CARD]-- the cards on the deck now
	all_players				:ARRAY[TR_PLAYER]
	who_bet_id				:INTEGER-- who press bet	

	the_player_turn_id		:INTEGER

	round_number			:INTEGER
	team1_score				:INTEGER
	team2_score				:INTEGER-- the team hwo send a bet
	betting_team			:INTEGER-- The team hwo send last bet
	current_game_points		:INTEGER
	current_bet				:STRING-- if there a bet  what's this bet
	end_hand				:BOOLEAN--true if and only if the end of the hand and be false otherwise
	the_winner				:TR_PLAYER
	end_game				:BOOLEAN--true if and only if the end of the hand and be false otherwise
	action					:BOOLEAN


	who_dealt				: INTEGER -- who was the one who dealt the card
feature{ANY}

	make
	local
		player_empty : TR_PLAYER
	do
		create rounds.make_filled (0, 0,2)
		create player_empty.make (0, 0)
		create the_winner.make (0,0)
		create the_deck_cards.make_empty
		create all_players.make_filled (player_empty,0,3)-- make all_players array with size 4 and initialize
		round_number:=0
		team1_score:=0
		team2_score:=0
		betting_team:=0
		the_player_turn_id:=0
		current_game_points:=0
		current_bet:=""
		end_hand:=false
		end_game:=false
		action:=false
		who_dealt := 0
	end

	set_round(a_team_id,a_round_number:INTEGER_32)
	require
		a_team_id>0 and a_round_number>=0
	do
		rounds.put ( a_team_id, a_round_number)
	end

	get_round():ARRAY[INTEGER]
	do
		result:= rounds
	end

	set_round_number(a_round_number:INTEGER)
	require
		a_round_number>0 and a_round_number<4
	do
		round_number:=a_round_number
	end

	get_round_number():INTEGER
	do
		result:= round_number
	end

	set_team1_score(a_team1_score:INTEGER)
	require
		a_team1_score>0
	do
		team1_score:=a_team1_score
	end

	get_team1_score():INTEGER
	do
		result:= team1_score
	end

	set_team2_score(a_team2_score:INTEGER)
	require
		a_team2_score>0
	do
		team2_score:=a_team2_score
	end

	get_team2_score():INTEGER
	do
		result:= team2_score
	end


	set_betting_team (a_betting_team :INTEGER)
	do
		betting_team :=a_betting_team
	end

	get_betting_team ():INTEGER
	do
		result:=  betting_team
	end

	set_current_game_points (a_current_game_points :INTEGER)
	do
		current_game_points :=a_current_game_points
	end

	get_current_game_points ():INTEGER
	do
		result:= current_game_points
	end

	set_current_bet (a_current_bet :STRING)
	do
		current_bet :=a_current_bet
	end

	get_current_bet ():STRING
	do
		result:= current_bet
	end

	set_who_bet_id(id:INTEGER)
	require
		id>0 and id<5
	do
		who_bet_id:=id
	end

	get_who_bet_id():INTEGER
	do
		result:=who_bet_id
	end

	set_end_hand()
	do
		end_hand:=true
	end

	set_end_hand_to_false()
	do
		end_hand:=false
	end

	get_end_hand():BOOLEAN
	do
		result:=end_hand
	end

	set_winner_round(a_winner:TR_PLAYER)
	do
		the_winner:=a_winner
	end

	get_winner_round():TR_PLAYER
	do
		result:=the_winner
	end

	set_end_game()
	do
		end_game:=true
	end

	set_end_game_to_false()
	do
		end_game:=false
	end

	get_end_game():BOOLEAN
	do
		result:=end_hand
	end

	update_deck_cards(the_cards:ARRAY[TR_CARD])
	do
		the_deck_cards.make_from_array (the_cards)
	end

	get_deck_cards():ARRAY[TR_CARD]
	do
		result:=the_deck_cards
	end

	is_envido_allowed(player: TR_PLAYER) : BOOLEAN
	do
		result:=is_first_round and current_bet.is_equal ("")
	end

	is_real_envido_allowed(local_player: TR_PLAYER):BOOLEAN
	do
		result:=(current_bet.is_equal ("envido") and get_action=true and (local_player.get_player_team_id /=betting_team))
	end

	is_falta_envido_allowed(local_player: TR_PLAYER) : BOOLEAN
	do
		result:=(current_bet.is_equal ("realenvido") and get_action=true and (local_player.get_player_team_id /=betting_team))
	end

	is_truco_allowed(player: TR_PLAYER) :BOOLEAN
	do
		result:=(current_bet.is_equal ("") and get_action()=false)
	end

	is_retruco_allowed(local_player: TR_PLAYER):BOOLEAN
	do
		result:=(current_bet.is_equal ("truco") and get_action()=true and (local_player.get_player_team_id /=betting_team))
	end

	is_vale_cuatro_allowed(local_player: TR_PLAYER):BOOLEAN
	do
		result:=(current_bet.is_equal ("retruco") and get_action()=true and (local_player.get_player_team_id /=betting_team))
	end



	set_action()
	do
		action:=true
	end

	remove_action()
	do
		action:=false
	end

	get_action():BOOLEAN
	do
		result:=action
	end


	set_all_players(the_all_players:ARRAY[TR_PLAYER])
	do
		all_players:=the_all_players
	end

	get_all_players():ARRAY[TR_PLAYER]
	do
		result:=all_players
	end

	do_i_have_to_play(id : INTEGER) : BOOLEAN
	do
        result:= not(action) and (the_player_turn_id=id)
	end

	do_i_have_to_answer_a_bet(id : INTEGER) : BOOLEAN
	do
		result := (action) and ((who_bet_id \\ 4)+1 = id)
	end


	hwo_is_next_player(player: TR_PLAYER):TR_PLAYER
	do
		if player.get_player_id<4 then
			result:=all_players[player.get_player_id]
		else
			result:=all_players[0]
		end
	end

feature -- dealing

	inc_who_dealt
	do
		who_dealt := who_dealt \\ 4 + 1
	end

feature -- player turn

	set_the_player_turn_id(a_player_id:INTEGER)
	require
		a_player_id>0 and a_player_id<5
	do
		the_player_turn_id:=a_player_id
	end

	get_the_player_turn_id : INTEGER
	do
		result := the_player_turn_id
	end

	inc_the_player_turn_id
	do
		the_player_turn_id := the_player_turn_id \\ 4 + 1
	end

feature --game status


	is_first_round : BOOLEAN
		-- indicates this is the first round
	do
		result := rounds[0] /= -1
	end

end

