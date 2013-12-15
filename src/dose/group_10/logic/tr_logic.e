note
        description: " {TR_LOGIC}represent the logic class for truco game"
        author: "tariqsenosy, RadwaSamy , AmiraMostafa"
        date: ""
        revision: ""

class
        TR_LOGIC

create
        make

feature{NONE,TR_TEST_LOGIC}

			cards				:ARRAY[TR_CARD]-- all game cards =  40 card
		deck_cards				:ARRAY[TR_CARD]-- the cards on deck it will be only 4 cards
		rounds					:ARRAY[INTEGER]-- save the id of winners in every round
		all_players				:ARRAY[TR_PLAYER]-- the 4 players array

		pos						:INTEGER -- counter for cards
		round_number			:INTEGER-- the round number 1  2  3
		team1_score				:INTEGER-- score of the team1
		team2_score				:INTEGER--score of the team2
		betting_team			:INTEGER-- The team hwo send last bet
		current_game_points		:INTEGER-- raise of the game , first it 1 but when you press envido and accept it will be 2 and so on
		current_bet				:STRING-- if there a bet  what's this bet

		action					:BOOLEAN--never mind
		who_bet_id				:INTEGER
		game_state_obj			:TR_GAME_STATE
		the_end_of_the_hand		:BOOLEAN
		final_winner			:INTEGER
			current_player_id	:INTEGER
			current_dealer_id	:INTEGER

		BC						: TR_BET_CONSTANTS

feature {ANY,TR_TEST_LOGIC}

	make
	--constractor that sets the players data to null , sets all cards randomly and sets Game_Points to 0
	local
		p:TR_PLAYER-- used to initialize the all_players array
		d:TR_CARD
	do
		create BC

		create game_state_obj.make
		create  p.make(0,0)-- create the player with id=0, teamid = 0
		create d.make ("",0)--  ceate card
		create all_players.make_filled (p,0,3)-- make all_players array with size 4 and initialize
		game_state_obj.set_all_players (all_players)
		create rounds.make_filled (-1, 0,2)-- array to save who win	

		create deck_cards.make_filled (d,0,3)-- cards on deck
		game_state_obj.update_deck_cards (deck_cards)
		create cards.make_filled (d,0,39)-- all cards in the game

		game_state_obj.set_the_player_turn_id (1)
		current_player_id:=1
		game_state_obj.set_the_player_turn_id (current_player_id)
		current_game_points:=0
		game_state_obj.set_current_game_points (current_game_points)
		round_number:=1
		game_state_obj.set_round_number (round_number)
		current_bet:=""
		game_state_obj.set_current_bet (current_bet)
		pos:=0
		current_dealer_id:=1
		the_end_of_the_hand:=false
		game_state_obj.set_end_hand_to_false
		put_the_cards
		make_cards_random_order
	end



----------------------------PUT_THE_CARDS-------------------------------------------

	put_the_cards-- create 40card and put them in the array cards
	local
		the_card:TR_CARD
		i:INTEGER_32
		v:INTEGER_32
		j:INTEGER
		x:INTEGER
	do
		create the_card.make ("null",0)
		create cards.make_filled (the_card , 0, 39)
		x:=0
		from
			j:=0
		until
			j>3
		loop
			v:=1
			from
				i:=0
			until
				i>9
			loop
				if v=8 or v=9  then
					v:=v+1
				else
					if j=0 then
						create the_card.make ("cups",v)             -- v from 1 to 12 without 8 9
					elseif j=1 then
						create the_card.make ("golds",v)
					elseif j=2 then
						create the_card.make ("swords",v)
					elseif j=3 then
						create the_card.make ("clubs",v)
					end
					cards.put (the_card, x)
					x:=x+1
					i:=i+1
					v:=v+1
				end
			end
			j:=j+1
		end
	end
-------------------------------------------------------------------------
	make_cards_random_order-- put cards on random order in random_cards
	local
		random_cards :ARRAY[TR_CARD]
		frbdn : ARRAY[TR_CARD]
		forbidden : BOOLEAN
		the_card : TR_CARD
		card : TR_CARD
		rand : RANDOM
		size : INTEGER
		index : INTEGER
		i : INTEGER
		x : INTEGER
		r : INTEGER
		j : INTEGER
		l_time: TIME
		l_seed: INTEGER
	do
		size := 39
		create card.make ("NULL", 0)
		create random_cards.make_filled (card , 0 , 39)
		create rand.make
		create l_time.make_now
		l_seed := l_time.hour
		l_seed := l_seed * 60 + l_time.minute
		l_seed := l_seed * 60 + l_time.second
		l_seed := l_seed * 1000 + l_time.milli_second
		rand.set_seed (l_seed)

		index := 39 - pos
		if index > 20 then
			forbidden := false
			index := 0
		else
			forbidden := true
		end
		--fill forbidden array
		if forbidden then
			create frbdn.make_filled (card , 0 , index)
			x := pos
			from
				i:=0
			until
				i>index
			loop
				create card.make (cards[x].get_card_type, cards[x].get_card_value)
				--frbdn.put (card, i)
				random_cards.put (card, i)
				size := size - 1
				i:=i+1
				x:=x+1
			end
			index := index + 1
		end
		--rest of cards in random
		j:=0
		from
			i := index
		until
			i > 39
		loop
			rand.forth
			r := rand.item
			x := (size+1)-j
			r := r\\x --determining upper limit
			create card.make (cards[r].get_card_type, cards[r].get_card_value)
			random_cards.put (card, i)
			remove(cards , r , size-j)
			j:=j+1
			i := i+1

		end
		cards := random_cards
	end
------------------------------------------------------
	remove (c:ARRAY[TR_CARD];index:INTEGER;size:INTEGER)
	local
		tmp : TR_CARD
	do
		create tmp.make ("null",0)
		tmp := c[index]
		c[index] := c[size]
		c[size] := tmp
	end

----------------------------------------------------------------------------

	set_player_info(a_name:STRING ;  a_id, a_team_id:INTEGER)-- will used by controller to send information
	local
		player : TR_PLAYER
	do
		create player.make (a_id, a_team_id)
		player.set_player_name(a_name)
		all_players[a_id-1] := player
		game_state_obj.set_all_players (all_players)
	end

-----------------------------------------------------------

	get_players():ARRAY[TR_PLAYER]
	do
		result := game_state_obj.get_all_players
	end
-----------------------------------------------------------
	get_cards():ARRAY[TR_CARD]
	do
		result:=cards
	end

----------------------------------Dealer----------------------------------
	dealer()
		-- Dealing the cards to the players, setting the dealer id and setting the player's who has to play id
		-- finally set the round number to 1 and reorder the players
	local
		array_of_cards:ARRAY[TR_CARD]
		a_card:TR_CARD
		i:INTEGER_32
		j:INTEGER
	do
		all_players := game_state_obj.get_all_players
		i := 1
		create a_card.make ("",i)
		if (39-pos) < 12 then
			make_cards_random_order
			pos:=0
		end
		from
			j:=0
		until
			j>3
		loop
			create array_of_cards.make_filled (a_card, 0,2)
			from
				i:=0
			until
				i>2
			loop
				create a_card.make (cards.item (pos).get_card_type,cards.item (pos).get_card_value)
				array_of_cards.put (a_card, i)
				pos:=pos+1
				i:=i+1
			end
			-- setting the players initial cards and points
			all_players[j].set_cards (array_of_cards)
			all_players[j].at_init_calculate_points
			j:=j+1
		end
		-- setting the new players
		game_state_obj.set_all_players (all_players)
		-- incrementing the person who distribued
		game_state_obj.inc_who_dealt
		current_dealer_id := game_state_obj.who_dealt
		-- incrementing the id person who has to play
		game_state_obj.set_the_player_turn_id (game_state_obj.who_dealt)
		game_state_obj.inc_the_player_turn_id
		current_player_id := game_state_obj.the_player_turn_id
		-- setting the round number to 1
		round_number := 1
		game_state_obj.set_round_number (1)
		-- setting the positions of the players
		set_players_positions (game_state_obj.the_player_turn_id)
	end

--------------------------------------------------------------------------------------------------------------

	set_round_number(num:INTEGER)--rounds seeter and getter will used by AI
	do
		round_number:=num
		game_state_obj.set_round_number (num)
	end

	get_round_number():INTEGER
	do
		result := game_state_obj.get_round_number
	end

----------------------------------------------------------------------------------------------------------------

	is_first_round():BOOLEAN
	do
		result:=game_state_obj.is_first_round
	end

----------------------------------------------------------------------------------------------------------------

	is_envido_allowed(player: TR_PLAYER) : BOOLEAN
	do
		result:=game_state_obj.is_envido_allowed (player)
	end

---------------------------------------------------------------------------------------------------

	send_envido(a_betting_player_id:INTEGER)
	require
		bet_possible : game_state_obj.is_envido_allowed (game_state_obj.all_players[a_betting_player_id-1])
	do
		game_state_obj.set_current_bet (BC.envido)
		game_state_obj.set_action
		current_bet:=BC.envido
		action:=true
		who_bet_id:=a_betting_player_id
		game_state_obj.set_who_bet_id (who_bet_id)

		if a_betting_player_id=1 or a_betting_player_id=3 then
			betting_team:=1
		else
			betting_team:=2
		end
		game_state_obj.set_betting_team (betting_team)
	end

 --------------------------------------------------------------------
	is_real_envido_allowed(local_player: TR_PLAYER):BOOLEAN
	do
		result:=game_state_obj.is_real_envido_allowed (local_player)
	end
-----------------------------------------------------------------------------------------------------------

	send_re_envido(a_betting_player_id:INTEGER)
	require
		bet_possible : game_state_obj.is_real_envido_allowed (game_state_obj.all_players[a_betting_player_id-1])
	do
		game_state_obj.set_current_bet (BC.real_envido)
		game_state_obj.set_action
		current_bet:=BC.real_envido
		action:=true
		who_bet_id:=a_betting_player_id
		game_state_obj.set_who_bet_id (who_bet_id)

		if a_betting_player_id=1 or a_betting_player_id=3 then
			betting_team:=1
		else
			betting_team:=2
		end

		game_state_obj.set_betting_team (betting_team)
	end
------------------------------------------------------------------------------------------------------------

    is_falta_envido_allowed(local_player: TR_PLAYER) : BOOLEAN
	do
		result:=game_state_obj.is_falta_envido_allowed (local_player)
	end

-----------------------------------------------------------------------------------------------------

	send_falta_envido(a_betting_player_id:INTEGER)
	require
		bet_possible : game_state_obj.is_falta_envido_allowed (game_state_obj.all_players[a_betting_player_id-1])
	do
		game_state_obj.set_current_bet (BC.falta_envido)
		game_state_obj.set_action
		current_bet:=BC.falta_envido
		action:=true
		who_bet_id:=a_betting_player_id
		game_state_obj.set_who_bet_id (who_bet_id)


		if a_betting_player_id=1 or a_betting_player_id=3 then
			betting_team:=1
		else
			betting_team:=2
		end

		game_state_obj.set_betting_team (betting_team)
	end
-------------------------------------------------------------------------------------------------------

	is_truco_allowed(player: TR_PLAYER) :BOOLEAN
	do
		result:=game_state_obj.is_truco_allowed (player)
	end

------------------------------------------------------------------------------------------------------------------------

	send_truco(a_betting_player_id:INTEGER)
	require
		bet_possible : game_state_obj.is_truco_allowed (game_state_obj.all_players[a_betting_player_id-1])
	do
		game_state_obj.set_current_bet (BC.truco)
		game_state_obj.set_action
		current_bet:=BC.truco
		action:=true
		who_bet_id:=a_betting_player_id
		game_state_obj.set_who_bet_id (who_bet_id)

		if a_betting_player_id=1 or a_betting_player_id=3 then
			betting_team:=1
		else
			betting_team:=2
		end

		game_state_obj.set_betting_team (betting_team)

	end
------------------------------------------------------------------------------------------------------------------------

	is_retruco_allowed(local_player: TR_PLAYER):BOOLEAN
	do
		result:=game_state_obj.is_retruco_allowed (local_player)
	end
------------------------------------------------------------------------------------------------------------------------

	send_re_truco(a_betting_player_id:INTEGER)
	require
		bet_possible : game_state_obj.is_retruco_allowed (game_state_obj.all_players[a_betting_player_id-1])
	do
		game_state_obj.set_current_bet (BC.retruco)
		game_state_obj.set_action
		current_bet:=BC.retruco
		action:=true
		who_bet_id:=a_betting_player_id
		game_state_obj.set_who_bet_id (who_bet_id)

		if a_betting_player_id=1 or a_betting_player_id=3 then
			betting_team:=1
		else
			betting_team:=2
		end
	   game_state_obj.set_betting_team (betting_team)

	end
---------------------------------------------------------------------------------------------------------------------

	is_vale_cuatro_allowed(local_player: TR_PLAYER):BOOLEAN
	do
		result:=game_state_obj.is_vale_cuatro_allowed (local_player)
	end

--------------------------------------------------------------------------------------------------------------------

	send_valle_cuatro(a_betting_player_id:INTEGER)
	require
		bet_possible : game_state_obj.is_vale_cuatro_allowed (game_state_obj.all_players[a_betting_player_id-1])
	do
		game_state_obj.set_current_bet (BC.vale_cuatro)
		game_state_obj.set_action
		current_bet:=BC.vale_cuatro
		action:=true
		who_bet_id:=a_betting_player_id
		game_state_obj.set_who_bet_id (who_bet_id)

		if a_betting_player_id=1 or a_betting_player_id=3 then
			betting_team:=1
		else
			betting_team:=2
		end

		game_state_obj.set_betting_team (betting_team)

	end


	send_accept(team:INTEGER)
	local
		add_score : INTEGER
		id : INTEGER
		cur_id : INTEGER
		count : INTEGER
		max : INTEGER
	do
		-- we get the players
		all_players := game_state_obj.get_all_players


		-- TRUCO

		if current_bet.is_equal (BC.truco) or current_bet.is_equal (BC.retruco) or current_bet.is_equal (BC.vale_cuatro) then
			-- we get the game points
			current_game_points := game_state_obj.get_current_game_points

			-- we increment it by one
			current_game_points := current_game_points+1

			-- we set the current_game points
			game_state_obj.set_current_game_points (current_game_points)

		-- ENVIDO		
		elseif current_bet.is_equal (BC.envido) or current_bet.is_equal (BC.real_envido) or current_bet.is_equal (BC.falta_envido) then

			-- we treat the bet to know the points we will need to add
			if current_bet.is_equal (BC.envido)  then
				add_score := 2
			elseif current_bet.is_equal (BC.real_envido)  then
				add_score := 3
			elseif current_bet.is_equal (BC.falta_envido)  then
				-- the falta envido is the points between the end of the game and the current score of the best team
				if (game_state_obj.team1_score > game_state_obj.team2_score) then
					add_score := 24 - game_state_obj.team1_score
				else
					add_score := 24 - game_state_obj.team2_score
				end
			end

			-- we are searching for the first player to have the highest envido points
			from
				count := 2
				id := get_id_from_position_in_round(1)
				max := all_players.at (id-1).cards_points
				cur_id := id \\ 4 + 1
			until
				count > 4
			loop
				if all_players.at (cur_id - 1).cards_points > max then
					max := all_players.at (cur_id - 1).cards_points
					id := cur_id
				end

				cur_id := cur_id \\ 4 + 1
				count := count + 1
			end

			-- we set the points of the best player
			if id = 1 or id = 3 then
                team1_score := team1_score + add_score
                all_players[0].set_player_team_score (team1_score)
                all_players[2].set_player_team_score (team1_score)
                game_state_obj.set_team2_score (team1_score)
			elseif id = 2 or id = 4 then
                team2_score := team2_score + add_score
                all_players[1].set_player_team_score (team2_score)
                all_players[3].set_player_team_score (team2_score)
                game_state_obj.set_team2_score (team2_score)
			end

		end

		action:=false
		game_state_obj.remove_action
	end

-------------------------------------------

	send_reject(team:INTEGER)
	local
		add_points : INTEGER
	do
		-- TRUCO		
		if current_bet.is_equal (BC.truco) or current_bet.is_equal (BC.retruco) or current_bet.is_equal (BC.vale_cuatro) then

			-- we get the game points
			add_points := game_state_obj.get_current_game_points

			-- we set that the hand is ended
			the_end_of_the_hand := True

		-- ENVIDO		
		elseif current_bet.is_equal (BC.envido) or current_bet.is_equal (BC.real_envido) or current_bet.is_equal (BC.falta_envido) then
			-- we treat the bet to know the points we will need to add
			if current_bet.is_equal (BC.envido)  then
				add_points := 1
			elseif current_bet.is_equal (BC.real_envido)  then
				add_points := 2
			elseif current_bet.is_equal (BC.falta_envido)  then
				add_points := 3
			end
		end

		-- set the points
		if team = 1 then
			team2_score := add_points
			all_players[1].set_player_team_score (team2_score)
			all_players[3].set_player_team_score (team2_score)
			game_state_obj.set_team2_score (team2_score)
		else
			team1_score := add_points
			all_players[0].set_player_team_score (team1_score)
			all_players[2].set_player_team_score (team1_score)
			game_state_obj.set_team1_score (team1_score)
		end

		action:=false
		game_state_obj.remove_action

	end





---------------------------------------------------------------------------------------------------------------------
	get_table_cards():ARRAY[TR_CARD]
	do
		result:=game_state_obj.the_deck_cards
	end
---------------------------------------------------------------------------------------------------------------------

	get_team_points(a_team_id:INTEGER):INTEGER
	require
		team_valid : a_team_id>0 and a_team_id<3
	do
		if a_team_id=1 then
			result:=game_state_obj.team1_score
		else
			result:=game_state_obj.team2_score
		end
	end
---------------------------------------------------------------------------------------------------------------------

	get_current_bet : STRING
	do
		result := game_state_obj.current_bet
	end

---------------------------------------------------------------------------------------------------------------------

	is_end_of_game : BOOLEAN
	do
		result := (game_state_obj.team1_score>=24 or game_state_obj.team2_score >= 24)
	end

feature

	get_id_from_position_in_round (position : INTEGER) : INTEGER
		-- returns a player ID from it's position in the round
	require
		position_is_possible : position >= 1 and position <= 4
	local
		i : INTEGER
		players : ARRAY[TR_PLAYER]
		id : INTEGER
		found : BOOLEAN
	do
		players := game_state_obj.get_all_players
		from
			id := -1
			i := players.lower
		until
			i > players.upper or found
		loop
			if players.at (i).get_player_posistion = position then
				id := i + 1
				found := True
			end
			i := i + 1
		end

		result := id

	ensure
		we_found_the_player : result /= -1
	end


	who_played_the_first_best_card : INTEGER
		-- returns the player who played the first best card in the round
	require
		round_ended : game_state_obj.rounds.at (game_state_obj.rounds.upper) /= -1
	local
		table_cards : ARRAY[TR_CARD]
		i : INTEGER
		max_weight : INTEGER
		position_max : INTEGER
	do
		from
			-- we get the cards and we remember the weight of the first card
			table_cards := game_state_obj.the_deck_cards
			position_max := table_cards.lower
			max_weight := table_cards.at (position_max).get_card_weight_truco
			i := table_cards.lower + 1
		until
			i > table_cards.upper
		loop
			-- if the current card is better than the old one we remember its position and weight
			if max_weight < table_cards.at (i).get_card_weight_truco then
				max_weight := table_cards.at (i).get_card_weight_truco
				position_max := i
			end
			i := i + 1
		end
		-- if there is more than one best card then there is a draw
		result := get_id_from_position_in_round(position_max + 1)
	end

----------------------------------------------------------------------------------------------------------------------
feature -- end of rounds

	is_there_a_draw : BOOLEAN
		-- returns if there is a draw or not in the current round
	require
		round_ended : game_state_obj.rounds.at (game_state_obj.rounds.upper) /= -1
	local
		table_cards : ARRAY[TR_CARD]
		i : INTEGER
		count : INTEGER
		max_weight : INTEGER
		position_max : INTEGER
	do
		from
			-- we get the cards and we remember the weight of the first card
			table_cards := game_state_obj.the_deck_cards
			count := 1
			position_max := table_cards.lower
			max_weight := table_cards.at (position_max).get_card_weight_truco
			i := table_cards.lower + 1
		until
			i > table_cards.upper
		loop
			-- if the current card is better than the old one we remember its weight
			if max_weight < table_cards.at (i).get_card_weight_truco then
				max_weight := table_cards.at (i).get_card_weight_truco
				position_max := i
				count := 1
			-- if the current card is as good as the old one
			-- and it is not my friends card
			-- we remember there is another better card
			elseif max_weight = table_cards.at (i).get_card_weight_truco and (i = position_max + 1 or i = position_max + 3) then
				count := count + 1
			end
			i := i + 1
		end
		-- if there is more than one best card then there is a draw
		result := count > 1
	end

	win_round(winner_id:INTEGER)
		-- set who wins the round (0 if it is a draw)
		-- in case of draw the winner must be the first to have play the highest card
	require
		round_ended : game_state_obj.rounds.at (game_state_obj.rounds.upper) /= -1
		id_possible : winner_id >= 1 and winner_id <= 3
	local
		draw : BOOLEAN
	do
		-- we get the round number from the game state
		round_number := game_state_obj.round_number

		-- first we look if there is a draw
		draw := is_there_a_draw

		-- if there is a draw we put that the winning player is 0	
		if draw then
			rounds.put (0,round_number-1)
			game_state_obj.set_round (0, round_number - 1)
		else
			rounds.put (winner_id,round_number-1)
			game_state_obj.set_round (winner_id, round_number - 1)
		end

		-- then we set the winner of the round
		set_players_positions(winner_id)
		game_state_obj.set_winner_round (winner_id)
	end


	end_round
		-- Make all modification necessary to the end of the round
		-- set the end of the hand to true in case it was the last round
	local
		winner_id : INTEGER
	do
		-- first we search for the best player
		winner_id := who_played_the_first_best_card

		-- then we call win round that set the winner of the round and does the necessary modifications
		win_round(winner_id)

		-- if we are in the first or second round
		-- we just go to the next round
		if round_number = 1 or round_number = 2 then
			round_number := round_number+1
			game_state_obj.set_round_number (round_number)
			the_end_of_the_hand:=False
			game_state_obj.set_end_hand_to_false
		-- else we call ed of hand
		elseif round_number = 3 then
			the_end_of_the_hand:=True
			game_state_obj.set_end_hand
		end
	end
-------------------------------------------------------------------------------------------


	set_current_game_state(the_game_state:TR_GAME_STATE)
	do
		game_state_obj:=the_game_state
		rounds:=game_state_obj.get_round
		current_player_id:=game_state_obj.the_player_turn_id
		round_number:=game_state_obj.get_round_number
		team1_score:=game_state_obj.get_team1_score
		team2_score:=game_state_obj.get_team2_score
		betting_team:=game_state_obj.get_betting_team
		current_game_points:=game_state_obj.get_current_game_points
		current_bet:=game_state_obj.get_current_bet
		who_bet_id:=game_state_obj.get_who_bet_id
		-- win_round (game_state_obj.get_winner_round)
		deck_cards:=game_state_obj.get_deck_cards
		action:=game_state_obj.get_action
		all_players:=game_state_obj.get_all_players
		current_dealer_id := game_state_obj.who_dealt
		the_end_of_the_hand := game_state_obj.end_hand
	end


	get_current_game_state():TR_GAME_STATE
	do
		result:=game_state_obj
	end
------------------------------------------------------------------------------------------------------------

	play_card(card: TR_CARD; local_player: TR_PLAYER)
	local
		i:INTEGER
		new_player_turn: INTEGER
		player_current_cards:ARRAY[TR_CARD]
	do
		all_players := game_state_obj.get_all_players
		local_player.set_player_current_card (card)
		create player_current_cards.make_from_array (local_player.get_player_cards)-- put player card here
		deck_cards.put (card.deep_twin,(local_player.get_player_posistion-1))
		game_state_obj.update_deck_cards (deck_cards)
		from
			i:=0
		until
			i>2
		loop
			if player_current_cards[i].get_card_type.is_equal (card.get_card_type)
				and player_current_cards[i].get_card_value=card.get_card_value	then
					player_current_cards[i].set_to_void()
					local_player.set_cards (player_current_cards)
					i:=2
			end
			i:=i+1
		end
		from
			i:=0
		until
			i=4
		loop
			if all_players.at (i).get_player_name.is_equal (local_player.get_player_name) then
				all_players.at (i) := local_player
				i:=3
			end
			i:=i+1
		end
		new_player_turn := game_state_obj.the_player_turn_id\\4 + 1
		game_state_obj.set_the_player_turn_id (new_player_turn)
		game_state_obj.set_all_players (all_players)
   end
--------------------------------------------------------------------------------------------------------------------------

	is_hand_ended():BOOLEAN
	do
		result:=the_end_of_the_hand
	end
--------------------------------------------------------------------------------------------

	end_hand()
	do
		-- we remember this is the end of the hand
		the_end_of_the_hand:=True
		game_state_obj.set_end_hand

		-- we empty the rounds winners array
		create rounds.make_filled (-1,0,2)
		game_state_obj.set_rounds(rounds)

		-- there is no more actions
		action:=false
		game_state_obj.remove_action

		-- there is no more bets
		current_bet:=""
		game_state_obj.set_current_bet ("")

		-- the cards played have to be deleted from the table
		create deck_cards.make_filled (Void, 0, 3)
		game_state_obj.update_deck_cards (deck_cards)

		-- we deal the cards
		dealer
	end

---------------------------------------------------------------------

	set_players_positions(winner_id:INTEGER)
	local
		j:INTEGER
		i:INTEGER
	do
		all_players := game_state_obj.get_all_players
		i:=winner_id-1
		from
			j:=0
		until
			j>3
		loop
			if i>3 then
				i:=0
			end
			all_players[i].set_player_posistion (j+1)
			j:=j+1
			i:=i+1
		end
		game_state_obj.set_all_players (all_players)
	end
-------------------------------------------------------

	end_game()
	require
		game_can_end : is_end_of_game
	do
		if team1_score >=24 then
			final_winner :=1
		else
			final_winner:= 2
		end
	end




   update_game_points(point: INTEGER)
                do
                current_game_points:=current_game_points+point
                game_state_obj.set_current_game_points (current_game_points)
                            end



  update_team_points(a_team_id,a_team_points:INTEGER)

                 do
                 if
                     a_team_id=1
                 then
                     team1_score:=team1_score+a_team_points
                     all_players[0].set_player_team_score (team1_score)
                        all_players[2].set_player_team_score (team1_score)
                        game_state_obj.set_team1_score (team1_score)

                 else
                      team2_score:=team2_score+a_team_points
                      all_players[1].set_player_team_score (team2_score)
                          all_players[3].set_player_team_score (team2_score)
                          game_state_obj.set_team2_score (team2_score)


                 end
   end



  --------------------------------------------------------------------------------------------

   hwo_is_next_player(player: TR_PLAYER):TR_PLAYER
                        do
                               if
                                       player.get_player_id<4
                               then
                                       result:=all_players[player.get_player_id]

                                       else
                                               result:=all_players[0]
                               end
 end

------------------------------------------------------------------------------------

  is_end_round():BOOLEAN
do

result:=not(deck_cards[3].get_card_type.is_equal(""))

end


--end_round()
--local
--c:TR_CARD
--do
--        create c.make ("",0)
--        c.set_to_void
--        all_players[0].set_player_current_card (c)
--        all_players[1].set_player_current_card (c)
--        all_players[2].set_player_current_card (c)
--        all_players[3].set_player_current_card (c)

--        if
--                all_players[1].get_player_posistion=deck_card_winner(deck_cards)
--                or all_players[3].get_player_posistion=deck_card_winner(deck_cards)
--        then
--                rounds.put (2,round_number-1)
--                game_state_obj.set_round (2,round_number-1)
--        else
--        rounds.put (1,round_number-1)
--        game_state_obj.set_round (1,round_number-1)

--        end
--        round_number:=round_number+1
--        game_state_obj.set_round_number (round_number)
--        if round_number=4 then end_hand
--        end
--  end
--------------------------------------------------------------------------------------


--deck_card_winner(the_card_in_array:ARRAY[TR_CARD]):INTEGER
--                local
--                        max:INTEGER
--                        i:INTEGER
--                        index:INTEGER
--                do
--                max:= -1
--                        from i:=0
--                        until i>3
--                        loop
--                                if the_card_in_array[i].get_card_weight_truco>max
--                                then
--                                        max := the_card_in_array[i].get_card_weight_truco
--                                        index:=i
--                                end
--                                i:=i+1
--                        end
--                        result := index
--                end

--------------------------------------------------------------------------------------

   get_round():ARRAY[INTEGER]
            do
              result:=rounds
            end



  set_current_player_id(id:INTEGER)
     do
          current_player_id:=id
          game_state_obj.set_the_player_turn_id (current_player_id)
   end

   get_current_player_id():INTEGER
      do
           result:=current_player_id
     end

   hwo_is_current_player ():TR_PLAYER
       do

        result:=all_players[get_current_player_id-1]
     end

do_i_have_to_play(id : INTEGER) : BOOLEAN

do
        result:= not(action) and (get_current_player_id=id)
 end

do_i_have_to_answer_a_bet(id : INTEGER) : BOOLEAN

do
result := (action) and ((who_bet_id \\ 4)+1 = id)
end



player_id_who_is_dealer: INTEGER
do
        result:=current_dealer_id
end

-----------------------this function has no meanning or not used --------------------

   update_player_scores(player:TR_PLAYER;points:INTEGER)
                do
                --ask  TR_PLAYER.set_score(current_score+points)
   end



  set_team(player_1,player_2:TR_PLAYER; the_team_id:INTEGER)
                        do
                        --player_1.set_team_id(the_team_id)
                        --player_2.set_team_id(the_team_id)
                        end

        update_table_cards(played_card:TR_CARD)
                do
                -- put the card to table array cards
                -- if array ==4
                   -- update the state and count points
                end

        update_player_cards(player:TR_PLAYER;played_card:TR_CARD)
                do
                --delete the card from cards array
                -- add it ti deck cards

                end

------------------------------------------


end
