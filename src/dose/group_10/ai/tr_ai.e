note
        description: "Ai Engine of the truco game. %N%
        % Basically take a TR_PLAYER (which will act as the machine) and TR_LOGIC (the current state of the game), %N%
        % and will return the smartest possible action to achieve win the game."
        author: "Justine Compagnon, Matías Donatti, Gaston Cucatti"
        date: "$06/11/2013$"
        revision: "Version 0.02"

class
        TR_AI

create
    make_ai,
    make_ai_with_players

feature {NONE} -- Initialization

    make_ai(new_difficulty:STRING)
           obsolete
                   "use make_ai_with_players"
    do
    end

        make_ai_with_players(new_difficulty:STRING;id_player_ai_1:INTEGER;id_player_ai_2:INTEGER; team_ai:INTEGER)
    -- Create a AI Engine, the identifier of the players is 2 and 4
    require
            new_difficulty_valid: new_difficulty.is_equal ("easy") or new_difficulty.is_equal ("difficult")
            Players_in_pairs_valid: id_player_ai_1 = 2 and id_player_ai_2 = 4
        do
        		create BC
                difficulty  := new_difficulty
                id_player_a := id_player_ai_1
                id_player_b := id_player_ai_2
                team := team_ai
        ensure
                Players_in_pairs_valid: id_player_a = 2 and id_player_b = 4
                difficulty_valid : difficulty.is_equal ("easy") or difficulty.is_equal ("difficult")
        end

feature {ANY} -- Update hand

        update_hand(player_ai_1:TR_PLAYER;player_ai_2:TR_PLAYER)
        --updates data for AI for the new hand
        require
                player_ai_1_valid: player_ai_1.get_player_id = id_player_a
                player_ai_2_valid: player_ai_2.get_player_id = id_player_b
        do
                --local copy of the array
                player_cards_a:= player_ai_1.get_player_cards.deep_twin
                player_cards_b:= player_ai_2.get_player_cards.deep_twin
                --sort the cards
                insertion_sort_by_weight_truco (player_cards_a)
                insertion_sort_by_weight_truco (player_cards_b)
                --tracking of cards played
                create played_cards_a.make_filled (false,player_cards_a.lower,player_cards_a.upper)
                create played_cards_b.make_filled (false,player_cards_b.lower,player_cards_b.upper)
                --calculation of the Envido
                envido_points_a := calculate_points(player_cards_a)
                envido_points_b := calculate_points(player_cards_b)
        end

feature {ANY} -- Next move

        next_action (current_player:TR_PLAYER; current_state_game:INTEGER):TR_ACTION
        obsolete
                   "use next_move"
        do
        end

    next_move (current_player_id:INTEGER; current_state_game:TR_LOGIC)
    -- Decide what will be the next move
    require
                player_id_valid: current_player_id = 2 or current_player_id = 4
                state_game_valid: current_state_game /= Void
          do
                if difficulty.is_equal ("easy") then
                    next_move_easy(current_player_id,current_state_game)
            else
                    next_move_difficult(current_player_id,current_state_game)
            end
    end

        next_move_easy(current_player_id:INTEGER; current_state_game:TR_LOGIC)
        -- Decide what will be the next move in mode easy
        require
                player_id_valid: current_player_id = id_player_a or current_player_id = id_player_b
                state_game_valid: current_state_game /= Void
        local
                game_state: TR_GAME_STATE
                bet, my_bet : STRING
                points : INTEGER
                current_player: TR_PLAYER
                player_cards: ARRAY[TR_CARD]
                played_cards: ARRAY[BOOLEAN]
                card_to_play : TR_CARD

                point_team_1:INTEGER
            point_team_2:INTEGER
            point_max: INTEGER
        do

                current_player := player_for_id (current_player_id, current_state_game.get_current_game_state.get_all_players)
                game_state := current_state_game.get_current_game_state
                bet := game_state.get_current_bet

                point_team_1 := current_state_game.get_team_points (1)
            point_team_2 := current_state_game.get_team_points (2)
            point_max := point_team_1
            if point_team_1 < point_team_2 then
                    point_max := point_team_2
            end

                if current_player_id = id_player_a then
                        points := envido_points_a
                    player_cards := player_cards_a
                    played_cards := played_cards_a
                elseif current_player_id = id_player_b then
                        points := envido_points_b
                        player_cards := player_cards_b
                    played_cards := played_cards_b
                end

                if current_state_game.get_current_game_state.do_i_have_to_answer_a_bet (current_player_id) then
                        if bet.is_equal(BC.Envido) OR bet.is_equal(BC.Real_envido) OR bet.is_equal(BC.Falta_envido) then
                                if accept_envido(points,bet,point_max) then
                                        my_bet := send_envido (current_player, points, point_max, current_state_game)
                                        if my_bet.is_equal(BC.Real_envido) then
                                                current_state_game.send_re_envido (current_player_id)
                                        elseif my_bet.is_equal(BC.Falta_envido) then
                                                current_state_game.send_falta_envido (current_player_id)
                                        else -- only accept
                                                current_state_game.send_accept (current_player_id)
                                        end
                                else
                                        current_state_game.send_reject (current_player.get_player_team_id)
                                end
                        else
                                if bet.is_equal(BC.Truco) OR bet.is_equal(BC.Retruco) OR bet.is_equal(BC.Vale_cuatro) then
                                        if accept_truco_easy (bet, current_state_game,player_cards,played_cards) then
                                                my_bet := send_truco_easy (current_state_game, current_player,player_cards,played_cards)
                                                if my_bet.is_equal(BC.Retruco) then
                                                        current_state_game.send_re_truco (current_player_id)
                                                elseif my_bet.is_equal(BC.Vale_cuatro) then
                                                        current_state_game.send_valle_cuatro (current_player_id)
                                                else -- only accept
                                                        current_state_game.send_accept (current_player_id)
                                                end
                                        else
                                                current_state_game.send_reject (current_player.get_player_team_id)
                                        end
                                end
                        end

                elseif current_state_game.get_current_game_state.do_i_have_to_play (current_player_id) then
                        my_bet := send_envido (current_player, points, point_max, current_state_game)
                        if my_bet.is_equal(BC.Envido) then
                                current_state_game.send_envido (current_player_id)
                        else
                                my_bet := send_truco_easy (current_state_game, current_player,player_cards,played_cards)
                                if my_bet.is_equal(BC.Truco) then
                                        current_state_game.send_truco (current_player_id)
                                elseif my_bet.is_equal(BC.Retruco) then
                                        current_state_game.send_re_truco (current_player_id)
                                elseif my_bet.is_equal(BC.Vale_cuatro) then
                                        current_state_game.send_valle_cuatro (current_player_id)
                                else
                                        card_to_play := play_card_easy(current_player_id, player_cards,played_cards,current_state_game)
                                        current_state_game.play_card (card_to_play, current_player)
                                end
                        end
                end
        end

        next_move_difficult(current_player_id:INTEGER; current_state_game:TR_LOGIC)
        -- Decide what will be the next move in mode difficult
        require
                player_id_valid: current_player_id = id_player_a or current_player_id = id_player_b
                state_game_valid: current_state_game /= Void
        local
                game_state: TR_GAME_STATE
                player_cards, partner_player_cards: ARRAY[TR_CARD]
                played_cards, partner_played_cards: ARRAY[BOOLEAN]
                current_player, partner_player: TR_PLAYER
                card_to_play : TR_CARD
                my_bet,bet: STRING
                points: INTEGER
                partner_player_id:INTEGER

                point_team_1:INTEGER
            point_team_2:INTEGER
            point_max: INTEGER
        do
                current_player := player_for_id (current_player_id, current_state_game.get_current_game_state.get_all_players)

                game_state := current_state_game.get_current_game_state
                bet := game_state.get_current_bet

                points := envido_points_a
                if points < envido_points_b then
                        points := envido_points_b
                end

                point_team_1 := current_state_game.get_team_points (1)
            point_team_2 := current_state_game.get_team_points (2)
            point_max := point_team_1
            if point_team_1 < point_team_2 then
                    point_max := point_team_2
            end

                if current_player_id = id_player_a then
                    player_cards := player_cards_a
                    played_cards := played_cards_a
                    partner_player_cards := player_cards_b
                    partner_played_cards := played_cards_b
                    partner_player_id := id_player_b
                elseif current_player_id = id_player_b  then
                        player_cards := player_cards_b
                    played_cards := played_cards_b
                           partner_player_cards := player_cards_a
                    partner_played_cards := played_cards_a
                    partner_player_id := id_player_a
                end

                partner_player := player_for_id (partner_player_id, current_state_game.get_current_game_state.get_all_players)

                if current_state_game.get_current_game_state.do_i_have_to_answer_a_bet (current_player_id) then
                        if bet.is_equal(BC.Envido) OR bet.is_equal(BC.Real_envido) OR bet.is_equal(BC.Falta_envido) then
                                if accept_envido(points,bet,point_max) then
                                        my_bet := send_envido (current_player, points, point_max, current_state_game)
                                        if my_bet.is_equal(BC.Real_envido) then
                                                current_state_game.send_re_envido (current_player_id)
                                        elseif my_bet.is_equal(BC.Falta_envido) then
                                                current_state_game.send_falta_envido (current_player_id)
                                        else -- only accept
                                                current_state_game.send_accept (current_player_id)
                                        end
                                else
                                        current_state_game.send_reject (current_player.get_player_team_id)
                                end
                        else
                                if bet.is_equal(BC.Truco) OR bet.is_equal(BC.Retruco) OR bet.is_equal(BC.Vale_cuatro) then
                                        if accept_truco_dif (bet, current_state_game,player_cards,played_cards,partner_player_cards,partner_played_cards) then
                                                my_bet :=  send_truco_difficulty (current_state_game, current_player,player_cards,played_cards,partner_player,partner_player_cards,partner_played_cards)
                                                if my_bet.is_equal(BC.Retruco) then
                                                        current_state_game.send_re_truco (current_player_id)
                                                elseif my_bet.is_equal(BC.Vale_cuatro) then
                                                        current_state_game.send_valle_cuatro (current_player_id)
                                                else -- only accept
                                                        current_state_game.send_accept (current_player_id)
                                                end
                                        else
                                                current_state_game.send_reject (current_player.get_player_team_id)
                                        end
                                end
                        end

                elseif current_state_game.get_current_game_state.do_i_have_to_play (current_player_id) then
                        my_bet := send_envido (current_player, points, point_max, current_state_game)
                        if my_bet.is_equal(BC.Envido) then
                                current_state_game.send_envido (current_player_id)
                        else
                                my_bet := send_truco_difficulty (current_state_game, current_player,player_cards,played_cards,partner_player,partner_player_cards,partner_played_cards)
                                if my_bet.is_equal(BC.Truco) then
                                        current_state_game.send_truco (current_player_id)
                                elseif my_bet.is_equal(BC.Retruco) then
                                        current_state_game.send_re_truco (current_player_id)
                                elseif my_bet.is_equal(BC.Vale_cuatro) then
                                        current_state_game.send_valle_cuatro (current_player_id)
                                else
                                        card_to_play := play_card_difficult(current_player_id, partner_player_id, player_cards,partner_player_cards,played_cards, partner_played_cards,current_state_game)
                                        current_state_game.play_card (card_to_play, current_player)
                                end
                        end
                end
        end

feature{NONE, TR_TEST_AI} -- aux next move

        player_for_id (id_player: INTEGER; all_players: ARRAY[TR_PLAYER]): TR_PLAYER
        local
                index:INTEGER
                found: BOOLEAN
                player: TR_PLAYER
        do
                from
                        index:= all_players.lower
                until
                        index > all_players.upper OR found
                loop
                        if id_player = all_players[index].get_player_id then
                                found := TRUE
                                player := all_players[index]
                        end
                        index:= index+1
                end
                result := player
        end

feature {NONE, TR_TEST_AI} --Accept

    accept_envido(envido_points: INTEGER ;proposition : STRING; point_team_max: INTEGER): BOOLEAN
    -- Decide to accept or refuses a proposition of 'Envido' or 'Real Envido' or 'Falta Envido'
    -- Accept Envido: if the point are above Floor_to_envido
    -- Accept Real Envido: if the points are above Floor_to_real_envido
    -- Accept Falta Envido: if the points are above Floor_to_falta_envido and if the nearest team to win missing 6 points
    require
		proposition_envido_valid: proposition.is_equal(BC.Envido) or proposition.is_equal(BC.Real_envido) or proposition.is_equal(BC.Falta_envido)
		point_team_max_valid:  point_team_max >= 0 AND point_team_max <= 24
		envido_points_valid:       envido_points >= 0 and envido_points <= 33
    local
    	send : BOOLEAN
	do
		if proposition.is_equal(BC.Envido) then
			if envido_points >= Floor_to_envido then
				send := True
			else
            	send:= False
        	end
		elseif proposition.is_equal(BC.Real_envido)  then
        	if envido_points >= Floor_to_real_envido then
            	send := True
            else
            	send := False
            end
       	elseif proposition.is_equal(BC.Falta_envido)  then
        	if envido_points >= Floor_to_falta_envido then
            --if the nearest team to win missing 6 points
            	if point_team_max > 18 then
                	send := True
                else
                	send := False
                end
           	else
            	send := False
			end
      	else
        	send := false
        end
        result := send
    end

	accept_truco_easy (proposition : String; current_state_game: TR_LOGIC;player1_card:ARRAY[TR_CARD]; played_card:ARRAY[BOOLEAN]):BOOLEAN
    -- Decide to accept or refuses a proposition of 'Truco'
    -- if  the AI won the first play and has one of the top four cards accept_truco
    -- the AI won the first play and has one of the top two cards accept_truco and send retruco ;
    require
		proposition_truco_valid: proposition.count>0
		player1_card_not_void: player1_card /= void
		played_card_not_void: played_card /= void
    local
		flag: BOOLEAN
		cards_available: ARRAY[TR_CARD]
		index: INTEGER
    do
    	create cards_available.make_filled (void,0,2)
		cards_available := card_available(player1_card, played_card)
		if proposition.is_equal(BC.Truco) then
			flag :=  bet_available (cards_available, 8)
		elseif proposition.is_equal(BC.Retruco) then
			flag :=  bet_available (cards_available, 10)
		elseif proposition.is_equal(BC.Vale_cuatro) then
			flag :=  bet_available (cards_available, 12)
		else
			flag := false
		end
		result := flag
	end


feature {NONE,TR_TEST_AI}
	accept_truco_dif (proposition : String; current_state_game: TR_LOGIC; current_player_card:ARRAY[TR_CARD]; current_played_card:ARRAY[BOOLEAN];partner_player_card:ARRAY[TR_CARD]; partner_played_card:ARRAY[BOOLEAN]):BOOLEAN
    require
		proposition_truco_valid: proposition.count > 0
		current_state_game_not_void: current_state_game /= void
		current_player_card_length: current_player_card.count = 3
		current_played_card_length: current_played_card.count = 3
		partner_player_card_length: partner_player_card.count = 3
		partner_played_card_length: partner_played_card.count = 3
	local
		flag: BOOLEAN
		current_cards_available: ARRAY[TR_CARD]
		partner_cards_available: ARRAY[TR_CARD]
		index: INTEGER
    do
    	create current_cards_available.make_filled (void, 0, 2)
    	create partner_cards_available.make_filled (void, 0, 2)
		current_cards_available := card_available(current_player_card, current_played_card)
		partner_cards_available := card_available(partner_player_card, partner_played_card)
		if proposition.is_equal(BC.Truco) then
			flag :=  bet_available (current_cards_available, 8) or bet_available (current_cards_available, 8)
		elseif proposition.is_equal(BC.Retruco) then
			flag := bet_available (current_cards_available, 10) or bet_available (current_cards_available, 10)
		elseif proposition.is_equal(BC.Vale_cuatro) then
			flag := bet_available (current_cards_available, 12) or bet_available (current_cards_available, 12)
		else
			flag := false
		end
		result := flag
	end



        card_available(card_player: ARRAY[TR_CARD];played_cards:ARRAY[BOOLEAN]):ARRAY[TR_CARD]
        require
                card_player_long: card_player.count = 3
                played_cards_long: played_cards.count = 3
        local
                index,count: INTEGER
                cards_available: ARRAY[TR_CARD]
        do
                count := 0
                from
                        index:=played_cards.lower
                until
                        index > played_cards.upper
                loop
                        if played_cards[index] = false then
                                count:=count+1
                        end
                        index := index+1
                end
                create cards_available.make_filled (void,0,count-1)

                from
                        index := card_player.lower
                until
                        index > card_player.upper
                loop
                        if played_cards[index] = false then
                                cards_available[index] := card_player[index]
                        end
                        index := index + 1
                end
                result := cards_available
        end

feature {NONE, TR_TEST_AI} --Send

    send_envido (player:TR_PLAYER; points_player:INTEGER;point_team_max: INTEGER;current_state_game:TR_LOGIC):STRING
    -- If I am 3rd or 4th pocicion of the round and envido,realenvido or faltaenvido allowed then
    -- Send Envido: if the point are above Floor_to_envido
    -- Send Realenvido: if the point are above Floor_to_real_envido
    -- Send Realenvido: if the points are above Floor_to_falta_envido and if the nearest team to win missing 6 points
    require
            current_state_game_no_void:  current_state_game /= void
            envido_points_valid:       points_player >= 0 and points_player <= 33
            player_no_void: player /=void
    local
            position_in_round : INTEGER
            chant : STRING
    do
            chant := ""
            position_in_round := player.get_player_posistion
            if position_in_round = 3 or position_in_round = 4 then
            --If I am 3rd or 4th pocicion of the round
                        if points_player > Floor_to_envido AND current_state_game.is_envido_allowed (player) then
                                chant := BC.Envido

                        elseif points_player > Floor_to_real_envido AND current_state_game.is_real_envido_allowed (player) then
                                chant := BC.Real_envido

                        elseif points_player > Floor_to_falta_envido AND current_state_game.is_falta_envido_allowed (player) then
                            if point_team_max > 18 then
                                        chant := BC.Falta_envido
                            end
                        end
                end
                result:= chant
        ensure
                expected_result: result.is_equal(BC.Envido) or  result.is_equal(BC.Real_envido) or result.is_equal(BC.Falta_envido) or result.is_equal("")
    end

        --need other parameters, cards_aviable, satet_game.
    send_truco_easy (current_state_game: TR_LOGIC;current_player: TR_PLAYER;current_card_player: ARRAY[TR_CARD]; current_played_card:ARRAY[BOOLEAN]): STRING
    --if  the AI won the first play and has one of the top four cards send truco
    --if  the AI won the first play and has a 2 or a 3 during the last turn send truco
    require
            player1_card_not_void: current_card_player /= void
            played_card_not_void: current_played_card /= void
    local
            flag: BOOLEAN
            cards_available_player_current: ARRAY[TR_CARD]
            index: INTEGER
            bet : STRING
    do
                cards_available_player_current := card_available(current_card_player, current_played_card)
                if current_state_game.is_truco_allowed(current_player) then
                        if current_state_game.get_round[0] = 2 or current_state_game.get_round[0] = 2 then
                                if bet_available(cards_available_player_current, 8) then
                                        bet := BC.Truco
                                end
                        end
                elseif current_state_game.is_retruco_allowed(current_player) then
                        if current_state_game.get_round[0] = 2 or current_state_game.get_round[0] = 2 then
                                if bet_available(cards_available_player_current,10) then
                                        bet := BC.Retruco
                                end
                        end

                elseif current_state_game.is_vale_cuatro_allowed(current_player) then
                        if current_state_game.get_round[0] = 2 or current_state_game.get_round[0] = 2 then
                                if bet_available(cards_available_player_current,12) then
                                        bet := BC.Vale_Cuatro
                                end
                        end

                else
                        bet := ""
                end
                result := bet
        ensure
                expected_result: result.is_equal(BC.Truco) or  result.is_equal(BC.Retruco) or result.is_equal(BC.Vale_Cuatro) or result.is_equal("")
    end


feature {NONE,TR_TEST_AI}

        bet_available(current_cards_player:ARRAY[TR_CARD]; number: INTEGER):BOOLEAN
        -- tell us if there is a card with a truco weight higher than a defined number
        -- if there is then the function return true else false
        require
                player1_cards_not_voy: current_cards_player /= void
                number_range: number >= 0 and number <= 13
        local
                index: INTEGER
                flag : BOOLEAN
        do
                from
                        index := current_cards_player.lower
                until
                        index > current_cards_player.upper or flag
                loop
                        if current_cards_player[index].get_card_weight_truco >= number then
                                flag := true
                        end
                        index:= index+1
                end
                result := flag
        end


        send_truco_difficulty(current_state_game: TR_LOGIC;current_player: TR_PLAYER;current_card_player: ARRAY[TR_CARD]; current_played_card:ARRAY[BOOLEAN];
                                                        partner_player: TR_PLAYER; partner_card_player: ARRAY[TR_CARD]; partner_played_card:ARRAY[BOOLEAN])        : STRING
        require
                current_card_player_count: current_card_player.count = 3
                current_played_card_count: current_played_card.count = 3
                partner_card_player_count: partner_played_card.count = 3
        local
                flag: BOOLEAN
            current_cards_available: ARRAY[TR_CARD]
            partner_cards_available: ARRAY[TR_CARD]
            index: INTEGER
            cards_on_the_table: ARRAY[TR_CARD]
            --random : RANDOM
        do
                create cards_on_the_table.make_empty
                current_cards_available := card_available(current_card_player, current_played_card)
                partner_cards_available := card_available(partner_card_player, partner_played_card)
                if current_state_game.is_truco_allowed (current_player) then
                        if current_state_game.get_round_number = 1 then
                                cards_on_the_table := prepare_the_table(cards_on_the_table, current_state_game.get_table_cards)
                                if team_bet_available(current_cards_available, partner_cards_available, 10) then
                                        flag := random_boolean()
                                end
                        elseif current_state_game.get_round_number = 2 then
                                cards_on_the_table := prepare_the_table(cards_on_the_table, current_state_game.get_table_cards)
                                if current_state_game.get_round[0] = current_player.get_player_team_id then
                                        if team_bet_available(current_cards_available, partner_cards_available,10) then
                                                flag := true
                                        end
                                else
                                        if two_older_cards(current_cards_available, partner_cards_available,10) then
                                                flag := true
                                        end
                                end
                        elseif current_state_game.get_round_number = 3 then
                                --Highest four cards played in the game
                                if play_the_highest_cards(cards_on_the_table) then
                                        if current_player.get_player_cards[2].get_card_value = 2 or current_player.get_player_cards[2].get_card_value = 3 or
                                                partner_player.get_player_cards[2].get_card_value = 2 or partner_player.get_player_cards[2].get_card_value = 3 then
                                                flag:= true
                                        end
                                elseif played_some_or_none_cards(cards_on_the_table) then

                                        if current_card_player[2].get_card_weight_truco = 13 then
                                                flag := true
                                        elseif current_card_player[2].get_card_weight_truco = 12 then
                                                if this_card_played(13,cards_on_the_table) then
                                                        flag := true
                                                else
                                                        flag := random_boolean()
                                                end
                                        elseif current_card_player[2].get_card_weight_truco = 11 then
                                                if this_card_played(13,cards_on_the_table) and this_card_played(12,cards_on_the_table)  then
                                                        flag := true
                                                else
                                                        flag := random_boolean()
                                                end
                                        elseif current_card_player[2].get_card_weight_truco = 10 then
                                                if this_card_played(13,cards_on_the_table) and this_card_played(12,cards_on_the_table) and this_card_played(11,cards_on_the_table) then
                                                        flag := true
                                                else
                                                        flag := random_boolean()
                                                end
                                        else
                                                flag := random_boolean()
                                        end
                                elseif not played_some_or_none_cards(cards_on_the_table)  then
                                        flag := random_boolean()
                                end
                        end
                        if flag then
                                result := BC.Truco
                        else
                                result := ""
                        end
                elseif(current_state_game.is_retruco_allowed (current_player)) then
                        if current_state_game.get_round_number = 1 then
                                cards_on_the_table := prepare_the_table(cards_on_the_table, current_state_game.get_table_cards)
                                if team_bet_available(current_cards_available, partner_cards_available, 10) then
                                        flag := random_boolean()
                                end
                        elseif current_state_game.get_round_number = 2 then
                                cards_on_the_table := prepare_the_table(cards_on_the_table, current_state_game.get_table_cards)
                                if current_state_game.get_round[0] = current_player.get_player_team_id then
                                        if team_bet_available(current_cards_available, partner_cards_available,10) then
                                                flag := true
                                        end
                                else
                                        if two_older_cards(current_cards_available, partner_cards_available,10) then
                                                flag := true
                                        end
                                end
                        elseif current_state_game.get_round_number = 3 then
                                --Highest four cards played in the game
                                if play_the_highest_cards(cards_on_the_table) then
                                        if current_player.get_player_cards[2].get_card_value = 2 or current_player.get_player_cards[2].get_card_value = 3 or
                                                partner_player.get_player_cards[2].get_card_value = 2 or partner_player.get_player_cards[2].get_card_value = 3 then
                                                flag:= true
                                        end
                                elseif played_some_or_none_cards(cards_on_the_table) then

                                        if current_card_player[2].get_card_weight_truco = 13 then
                                                flag := true
                                        elseif current_card_player[2].get_card_weight_truco = 12 then
                                                if this_card_played(13,cards_on_the_table) then
                                                        flag := true
                                                else
                                                        flag := random_boolean()
                                                end
                                        elseif current_card_player[2].get_card_weight_truco = 11 then
                                                if this_card_played(13,cards_on_the_table) and this_card_played(12,cards_on_the_table)  then
                                                        flag := true
                                                else
                                                        flag := random_boolean()
                                                end
                                        elseif current_card_player[2].get_card_weight_truco = 10 then
                                                if this_card_played(13,cards_on_the_table) and this_card_played(12,cards_on_the_table) and this_card_played(11,cards_on_the_table) then
                                                        flag := true
                                                else
                                                        flag := random_boolean()
                                                end
                                        else
                                                flag := random_boolean()
                                        end
                                elseif not played_some_or_none_cards(cards_on_the_table)  then
                                        flag := random_boolean()
                                end
                        end
                        if flag then
                                result := BC.Retruco
                        else
                                result := ""
                        end
                elseif(current_state_game.is_vale_cuatro_allowed (current_player)) then
                        if current_state_game.get_round_number = 1 then
                                cards_on_the_table := prepare_the_table(cards_on_the_table, current_state_game.get_table_cards)
                                if team_bet_available(current_cards_available, partner_cards_available, 10) then
                                        flag := random_boolean()
                                end
                        elseif current_state_game.get_round_number = 2 then
                                cards_on_the_table := prepare_the_table(cards_on_the_table, current_state_game.get_table_cards)
                                if current_state_game.get_round[0] = current_player.get_player_team_id then
                                        if team_bet_available(current_cards_available, partner_cards_available,10) then
                                                flag := true
                                        end
                                else
                                        if two_older_cards(current_cards_available, partner_cards_available,10) then
                                                flag := true
                                        end
                                end
                        elseif current_state_game.get_round_number = 3 then
                                --Highest four cards played in the game
                                if play_the_highest_cards(cards_on_the_table) then
                                        if current_player.get_player_cards[2].get_card_value = 2 or current_player.get_player_cards[2].get_card_value = 3 or
                                                partner_player.get_player_cards[2].get_card_value = 2 or partner_player.get_player_cards[2].get_card_value = 3 then
                                                flag:= true
                                        end
                                elseif played_some_or_none_cards(cards_on_the_table) then

                                        if current_card_player[2].get_card_weight_truco = 13 then
                                                flag := true
                                        elseif current_card_player[2].get_card_weight_truco = 12 then
                                                if this_card_played(13,cards_on_the_table) then
                                                        flag := true
                                                else
                                                        flag := random_boolean()
                                                end
                                        elseif current_card_player[2].get_card_weight_truco = 11 then
                                                if this_card_played(13,cards_on_the_table) and this_card_played(12,cards_on_the_table)  then
                                                        flag := true
                                                else
                                                        flag := random_boolean()
                                                end
                                        elseif current_card_player[2].get_card_weight_truco = 10 then
                                                if this_card_played(13,cards_on_the_table) and this_card_played(12,cards_on_the_table) and this_card_played(11,cards_on_the_table) then
                                                        flag := true
                                                else
                                                        flag := random_boolean()
                                                end
                                        else
                                                flag := random_boolean()
                                        end
                                elseif not played_some_or_none_cards(cards_on_the_table)  then
                                        flag := random_boolean()
                                end
                        end
                        if flag then
                                result := BC.Vale_cuatro
                        else
                                result := ""
                        end
                end

        ensure
                expected_result: result.is_equal(BC.Truco) or  result.is_equal(BC.Retruco) or result.is_equal(BC.Vale_Cuatro) or result.is_equal("")
        end




        random_boolean():BOOLEAN
        require
        local
                flag:BOOLEAN
                random: RANDOM

                l_time : TIME
                l_seed : INTEGER
        do
                create l_time.make_now
              l_seed := l_time.hour
              l_seed := l_seed * 60 + l_time.minute
              l_seed := l_seed * 60 + l_time.second
              l_seed := l_seed * 1000 + l_time.milli_second
              create random.set_seed (l_seed)
                random.forth
                if random.item \\ 2 = 0 then
                        flag := true
                else
                        flag := false
                end
                result := flag
        end

        this_card_played(number:INTEGER; cards_the_desk: ARRAY[TR_CARD]):BOOLEAN
        require
                number < 14 and number > 0
        local
                index:INTEGER
                flag: BOOLEAN
        do
                from
                        index := cards_the_desk.lower
                until
                        index > cards_the_desk.upper or flag
                loop
                        if cards_the_desk.at (index).get_card_weight_truco = number then
                                flag := true
                        end
                        index := index+1
                end
        result := flag
        end



        two_older_cards(current_cards_available : ARRAY[TR_CARD] partner_cards_available : ARRAY[TR_CARD]; number : INTEGER):BOOLEAN
        require
        local
                index : INTEGER
                count : INTEGER
        do
                count := 0
                from
                        index := current_cards_available.lower
                until
                        index > current_cards_available.upper or count = 2
                loop
                        if current_cards_available[index].get_card_weight_truco >= number  then
                                count := count + 1
                        elseif partner_cards_available[index].get_card_weight_truco >= number then
                                count := count +1
                        end
                        index := index + 1
                end
                result := count >= 2
        end


feature {NONE,TR_TEST_AI}
        prepare_the_table(cards_on_the_table : ARRAY[TR_CARD] ; table_cards : ARRAY[TR_CARD]):ARRAY[TR_CARD]
        require
                table_cards_not_void : table_cards /= void
        local
                index: INTEGER
                array_result : ARRAY[TR_CARD]
        do
                create array_result.make_empty
                if cards_on_the_table.is_empty then
                        array_result.copy (table_cards)
                else
                        array_result.copy (cards_on_the_table)
                                from
                                        index := table_cards.lower
                                until
                                        index > table_cards.upper
                                loop
                                        print ("la taille du tableau est de : " + array_result.count.out + "%N" )
                                        array_result.grow (array_result.count + 1)
                                        print ("la taille du tableau est de : " + array_result.count.out + "%N" )
                                        print ("array.upper := " + array_result.upper.out + "%N" )
                                        print (" dans l'avant derniere case il y a : " + array_result[array_result.upper - 1].get_card_value.out + "%N")
                                        array_result[array_result.upper] := table_cards.at (index) --add_last(table_cards[index])
                                        print (" dans la derniere case il y a : " + array_result[array_result.upper].get_card_value.out + "%N")
                                        index := index + 1
                                end

                end

                result := array_result
        ensure
                expectede_result : result /= void
        end


        --played_three_older_cards():([(INTEGER, INTEGER)],BOOLEAN)

        play_the_highest_cards(cards_on_the_table : ARRAY[TR_CARD]):BOOLEAN
        local
                index:INTEGER
                flag_7_gold: BOOLEAN
                flag_7_swords: BOOLEAN
                flag_1_club: BOOLEAN
                flag_1_swords: BOOLEAN
        do
                from
                        index := cards_on_the_table.lower
                until
                        index > cards_on_the_table.upper or (flag_7_gold and flag_7_swords and flag_1_club and flag_1_swords)
                loop
                        if cards_on_the_table[index].get_card_weight_truco = 10 then
                                flag_7_gold := true
                        elseif cards_on_the_table[index].get_card_weight_truco = 11 then
                                flag_7_swords := true
                        elseif cards_on_the_table[index].get_card_weight_truco = 12 then
                                flag_1_club := true
                        elseif cards_on_the_table[index].get_card_weight_truco = 13 then
                                flag_1_swords := true
                        end
                        index := index + 1
                end
                result := flag_7_gold and flag_7_swords and flag_1_club and flag_1_swords
        end



        played_some_or_none_cards(cards_on_the_table : ARRAY[TR_CARD]):BOOLEAN
        require
        local
                index:INTEGER
                flag_7_gold: BOOLEAN
                flag_7_swords: BOOLEAN
                flag_1_club: BOOLEAN
                flag_1_swords: BOOLEAN
        do
                from
                        index := cards_on_the_table.lower
                until
                        index > cards_on_the_table.upper or flag_7_gold or flag_7_swords or flag_1_club or flag_1_swords
                loop
                        if cards_on_the_table[index].get_card_weight_truco = 10 then
                                flag_7_gold := true
                        elseif cards_on_the_table[index].get_card_weight_truco = 11 then
                                flag_7_swords := true
                        elseif cards_on_the_table[index].get_card_weight_truco = 12 then
                                flag_1_club := true
                        elseif cards_on_the_table[index].get_card_weight_truco = 13 then
                                flag_1_swords := true
                        end
                        index := index + 1
                end
                result := flag_7_gold or flag_7_swords or flag_1_club or flag_1_swords
        end


feature {NONE,TR_TEST_AI}

        --sum_of_cards_played():INTEGER_32

        team_bet_available(current_cards_player:ARRAY[TR_CARD]; partner_cards_player:ARRAY[TR_CARD];number: INTEGER):BOOLEAN
        -- tell us if there is a card coming from one of the ais game with a truco weight higher than a defined number
        -- if there is then the function return true else false
        require
                current_cards_player_not_void: current_cards_player /= void
                partner_cards_player_not_void: partner_cards_player /= void
                equals_long: current_cards_player.count = partner_cards_player.count
                number_correct: number >= 0 and number <= 13
        local
                index: INTEGER
                flag : BOOLEAN
        do
                from
                        index := current_cards_player.lower
                until
                        index > current_cards_player.upper or flag
                loop
                        if current_cards_player[index].get_card_weight_truco >= number or partner_cards_player[index].get_card_weight_truco >= number then
                                flag := true
                        end
                        index:= index+1
                end
                result := flag
        end

feature {NONE,TR_TEST_AI} --Card to play

    play_card_easy(id_player:INTEGER; card_player: ARRAY[TR_CARD];played_cards:ARRAY[BOOLEAN]; game_state:TR_LOGIC):TR_CARD
    -- if we can play a better card than the one that are on the table then we play it (the lowest
    -- card we have and beat all the others). if not we play the lowest one we have
    require
            game_state_no_void : game_state  /= VOID
            card_player_no_void: card_player /= VOID
            card_player_valid_length : card_player.count  = 3
            played_cards_valid_length: played_cards.count = 3
            id_player_valid : id_player >= 1 AND id_player <= 4
    local
            my_position:INTEGER
            pos_partner : INTEGER
            pos_opponent1,pos_opponent2:INTEGER

            weight_truco_o1, weight_truco_o2: INTEGER
            weight_truco_p: INTEGER
            max_op_position, max_weigth_op:INTEGER

            all_players:ARRAY[TR_PLAYER]
            table_cards: ARRAY[TR_CARD]
            card_to_play: TR_CARD

    do
            table_cards := game_state.get_table_cards
            all_players := game_state.get_current_game_state.get_all_players
            my_position := position_in_the_round(id_player,all_players)

                inspect
                        my_position
                when 1 then
                        -- play card smaller
                        card_to_play := smaller_card_available(card_player,played_cards)
                        mark_a_card(card_to_play,card_player,played_cards)
                        Result := card_to_play

                when 2 then
                        -- play the smallest card that kills the opponent's card. or play card smaller.
                        card_to_play:= optimal_card_to_play(card_player,played_cards,table_cards[0])
                        mark_a_card(card_to_play,card_player,played_cards)
                        Result := card_to_play

                when 3 then
                        -- if my team is winning the round play card smaller else
                        -- play the smallest card that kills the opponent's card. or play card smaller.
                        pos_opponent1 := 2
                        pos_partner   := 1
                        weight_truco_o1 := table_cards[pos_opponent1-1].get_card_weight_truco
                        weight_truco_p  := table_cards[pos_partner-1].get_card_weight_truco
                        if weight_truco_o1 < weight_truco_p  then
                                card_to_play := smaller_card_available(card_player,played_cards)
                        else
                                card_to_play := optimal_card_to_play(card_player,played_cards,table_cards[pos_opponent1-1])
                        end
                        mark_a_card(card_to_play,card_player,played_cards)
                        Result := card_to_play

                else -- position 4
                        -- if my team is winning the round play card smaller else
                        -- play the smallest card that kills the biggest card of my opponents. or play card smaller.
                        pos_opponent1 := 3
                        pos_opponent2 := 1
                        pos_partner := 2

                        weight_truco_o1 := table_cards[pos_opponent1-1].get_card_weight_truco
                        weight_truco_o2 := table_cards[pos_opponent2-1].get_card_weight_truco
                        max_weigth_op := weight_truco_o1
                        max_op_position := pos_opponent1
                        if max_weigth_op < weight_truco_o2 then
                                max_weigth_op := weight_truco_o2
                                max_op_position := pos_opponent2
                        end

                        weight_truco_p  := table_cards[pos_partner-1].get_card_weight_truco
                        if max_weigth_op < weight_truco_p  then
                                card_to_play := smaller_card_available(card_player,played_cards)
                        else
                                card_to_play := optimal_card_to_play(card_player,played_cards,table_cards[max_op_position-1])
                        end
                        mark_a_card(card_to_play,card_player,played_cards)

                        Result := card_to_play
                end
        ensure
                card_no_void: result /= VOID
    end


     play_card_difficult(id_player:INTEGER; id_team_mate:INTEGER; card_player:ARRAY[TR_CARD];card_team_mate:ARRAY[TR_CARD]; played_cards:ARRAY[BOOLEAN]; team_mate_played_cards:ARRAY[BOOLEAN]; game_state:TR_LOGIC):TR_CARD
    -- if we can play a better card than the one that are on the table then we play it (the lowest
    -- card we have and beat all the others). if not we play the lowest one we have
    require
            game_state_no_void : game_state  /= VOID
            card_player_no_void: card_player /= VOID
            card_player_valid_length : card_player.count  = 3
            played_cards_valid_length: played_cards.count = 3
            id_player_valid : id_player >= 1 AND id_player <= 4
    local
            my_position:INTEGER
            pos_partner : INTEGER
            pos_opponent1,pos_opponent2:INTEGER

            weight_truco_o1, weight_truco_o2: INTEGER
            weight_truco_p: INTEGER
            weight_truco_mine : INTEGER
            max_op_position, max_weigth_op:INTEGER

            all_players:ARRAY[TR_PLAYER]
            table_cards: ARRAY[TR_CARD]

            who_won_first_round : INTEGER

            my_best_card,best_partner_card: TR_CARD
                my_smaller_card,smaller_partner_card: TR_CARD
                my_highest_card_is_optimal: BOOLEAN
                partner_highest_card_is_optimal: BOOLEAN
                team_opponent : INTEGER

    do
            table_cards := game_state.get_table_cards
            all_players := game_state.get_current_game_state.get_all_players
            my_position := position_in_the_round(id_player,all_players)
                pos_partner := position_in_the_round(id_team_mate,all_players)
                team_opponent := team + 1
                if team_opponent = 3 then
                        team_opponent := 1
                end

                inspect
                        my_position
                when 1 then
                        if (game_state.get_round_number = 1) then
                        --in the first round I have all the cards available
                                my_best_card := card_player[card_player.upper]
                                best_partner_card := card_team_mate[card_team_mate.upper]
                                weight_truco_mine := my_best_card.get_card_weight_truco
                                weight_truco_p := best_partner_card.get_card_weight_truco

                                my_highest_card_is_optimal := weight_truco_mine > weight_truco_p AND weight_truco_mine >= 9
                                partner_highest_card_is_optimal := weight_truco_mine < weight_truco_p AND weight_truco_p >= 9

                                if my_highest_card_is_optimal then
                                        -- I play my highest
                                        mark_a_card(my_best_card,card_player,played_cards)
                                        result :=  my_best_card
                                elseif partner_highest_card_is_optimal then
                                        -- I play my lowest
                                        mark_a_card(card_player[card_player.lower],card_player,played_cards)
                                        result :=  card_player[card_player.lower]
                                else
                                        if card_player[card_player.lower+1].get_card_weight_truco >= 8 then
                                                mark_a_card(card_player[card_player.lower+1],card_player,played_cards)
                                                result := card_player[card_player.lower+1]
                                        else
                                                mark_a_card(card_player[card_player.lower],card_player,played_cards)
                                                result := card_player[card_player.lower]
                                        end
                                end

                        elseif (game_state.get_round_number = 2) then
                        --if I'm first in the second round: is because my team won the first round, or there was a tie
                                who_won_first_round := game_state.get_round.at (game_state.get_round.lower)
                                -- If we won the first round
                                if who_won_first_round = team then
                                        my_best_card := greater_card_available(card_player,played_cards)
                                        best_partner_card := greater_card_available(card_team_mate,team_mate_played_cards)
                                        if my_best_card.get_card_weight_truco < best_partner_card.get_card_weight_truco then
                                        -- I play the highest
                                                mark_a_card(my_best_card,card_player,played_cards)
                                                result := my_best_card
                                        else
                                        -- I play my lowest
                                                my_smaller_card := smaller_card_available(card_player,played_cards)
                                                mark_a_card(my_smaller_card,card_player,played_cards)
                                                result := my_smaller_card
                                        end
                                else -- If it is par
                                -- I play my highest one
                                        my_best_card := greater_card_available(card_player,played_cards)
                                        mark_a_card(my_best_card,card_player,played_cards)
                                        result := my_best_card
                                end
                        else -- third round
                                my_smaller_card := smaller_card_available(card_player,played_cards)
                                mark_a_card(my_smaller_card,card_player,played_cards)
                                result := my_smaller_card
                        end

                when 2 then

                        if (game_state.get_round_number = 1) then
                        --in the first round I have all the cards available
                                my_best_card := card_player[card_player.upper]
                                best_partner_card := card_team_mate[card_team_mate.upper]
                                weight_truco_mine := my_best_card.get_card_weight_truco
                                weight_truco_p := best_partner_card.get_card_weight_truco

                                my_highest_card_is_optimal := weight_truco_mine > weight_truco_p AND weight_truco_mine >= 9
                                partner_highest_card_is_optimal := weight_truco_mine < weight_truco_p AND weight_truco_p >= 9

                                if my_highest_card_is_optimal AND table_cards[table_cards.lower].get_card_weight_truco < weight_truco_mine then
                                -- I play my highest
                                        mark_a_card(my_best_card,card_player,played_cards)
                                        result :=  my_best_card
                                elseif partner_highest_card_is_optimal then
                                -- I play my lowest
                                        mark_a_card(card_player[card_player.lower],card_player,played_cards)
                                        result :=  card_player[card_player.lower]
                                else
                                -- I play opptimal
                                        my_smaller_card := optimal_card_to_play(card_player,played_cards,table_cards[table_cards.lower])
                                        mark_a_card(my_smaller_card,card_player,played_cards)
                                        result := my_smaller_card
                                end

                        elseif (game_state.get_round_number = 2) then
                        --if I'm second in the second round: is because my team not won  the first round, or there was a tie.
                                who_won_first_round := game_state.get_round.at (team)
                                if who_won_first_round = team_opponent then
                                        my_best_card := greater_card_available(card_player,played_cards)
                                        best_partner_card := greater_card_available(card_team_mate,team_mate_played_cards)
                                        my_smaller_card := smaller_card_available(card_player,played_cards)
                                        smaller_partner_card := smaller_card_available(card_team_mate,team_mate_played_cards)

                                        if my_best_card.get_card_weight_truco < smaller_partner_card.get_card_weight_truco then
                                        -- if my friend has the two highest ones, I play my highest one
                                                mark_a_card(my_best_card,card_player,played_cards)
                                                result := my_best_card
                                        elseif my_best_card.get_card_weight_truco < best_partner_card.get_card_weight_truco then
                                                -- if my friend has only the highest one, I play my lowest
                                                mark_a_card(my_smaller_card,card_player,played_cards)
                                                result := my_smaller_card
                                        else
                                        -- I play my highest
                                                mark_a_card(my_best_card,card_player,played_cards)
                                                result := my_best_card
                                        end
                                else -- If it is par
                                -- I play my highest one
                                        my_best_card := greater_card_available(card_player,played_cards)
                                        mark_a_card(my_best_card,card_player,played_cards)
                                        result := my_best_card
                                end
                        else -- third round
                                my_smaller_card := smaller_card_available(card_player,played_cards)
                                mark_a_card(my_smaller_card,card_player,played_cards)
                                result := my_smaller_card
                        end

                when 3 then

                        if (game_state.get_round_number = 1) then
                        --in the first round I have all the cards available
                                my_best_card := card_player[card_player.upper]
                                weight_truco_mine := my_best_card.get_card_weight_truco
                                weight_truco_p :=  table_cards[table_cards.lower].get_card_weight_truco
                                weight_truco_o1 := table_cards[table_cards.lower+1].get_card_weight_truco

                                my_highest_card_is_optimal := weight_truco_mine > weight_truco_p AND weight_truco_mine >= 9
                                partner_highest_card_is_optimal := weight_truco_mine < weight_truco_p

                                if my_highest_card_is_optimal AND weight_truco_mine > weight_truco_o1 AND weight_truco_p <= 8  then
                                        -- I play my highest
                                        mark_a_card(my_best_card,card_player,played_cards)
                                        result :=  my_best_card
                                elseif partner_highest_card_is_optimal then
                                        -- I play my lowest
                                        mark_a_card(card_player[card_player.lower],card_player,played_cards)
                                        result :=  card_player[card_player.lower]
                                else
                                        if weight_truco_p < weight_truco_o1 OR weight_truco_p <= 8 then
                                        -- I play optimal
                                                my_smaller_card := optimal_card_to_play(card_player,played_cards,table_cards[table_cards.lower+1])
                                                mark_a_card(my_smaller_card,card_player,played_cards)
                                                result := my_smaller_card
                                        else
                                                mark_a_card(card_player[card_player.lower],card_player,played_cards)
                                                result := card_player[card_player.lower]
                                        end
                                end

                        elseif (game_state.get_round_number = 2) then
                        --if I'm third in the second round: is because my team won the first round, or there was a tie
                                who_won_first_round := game_state.get_round.at (game_state.get_round.lower)
                                -- If we won the first round
                                if who_won_first_round = team then
                                        weight_truco_p :=  table_cards[table_cards.lower].get_card_weight_truco
                                        weight_truco_o1 := table_cards[table_cards.lower+1].get_card_weight_truco

                                        if weight_truco_p < weight_truco_o1 then
                                        -- if my friend has the two highest ones, I play my highest one
                                                my_smaller_card := optimal_card_to_play(card_player,played_cards,table_cards[table_cards.lower+1])
                                                mark_a_card(my_smaller_card,card_player,played_cards)
                                                result := my_smaller_card
                                        else
                                                -- if my friend has only the highest one, I play my lowest
                                                my_smaller_card := smaller_card_available(card_player,played_cards)
                                                mark_a_card(my_smaller_card,card_player,played_cards)
                                                result := my_smaller_card
                                        end
                                else -- If it is par
                                        my_best_card := greater_card_available(card_player,played_cards)
                                        mark_a_card(my_best_card,card_player,played_cards)
                                        result := my_best_card
                                end
                        else
                                my_smaller_card := smaller_card_available(card_player,played_cards)
                                mark_a_card(my_smaller_card,card_player,played_cards)
                                result := my_smaller_card
                        end

                else -- position 4
                        pos_opponent1 := 3
                        pos_opponent2 := 1
                        pos_partner := 2

                        weight_truco_o1 := table_cards[pos_opponent1].get_card_weight_truco
                        weight_truco_o2 := table_cards[pos_opponent2].get_card_weight_truco
                        max_weigth_op := weight_truco_o1
                        max_op_position := pos_opponent1
                        if max_weigth_op < weight_truco_o2 then
                                max_weigth_op := weight_truco_o2
                                max_op_position := pos_opponent2
                        end

                        weight_truco_p  := table_cards[pos_partner].get_card_weight_truco
                        if max_weigth_op < weight_truco_p  then
                                my_smaller_card := smaller_card_available(card_player,played_cards)
                                mark_a_card(my_smaller_card,card_player,played_cards)
                                result := my_smaller_card
                        else
                                my_smaller_card := optimal_card_to_play(card_player,played_cards,table_cards[max_op_position])
                                mark_a_card(my_smaller_card,card_player,played_cards)
                                result := my_smaller_card
                        end
                end
        ensure
                card_no_void: result /= VOID
    end

feature {NONE,TR_TEST_AI} -- Aux Play Card

        id_player_for_position(position:INTEGER; all_players: ARRAY[TR_PLAYER]):INTEGER
        --returns the id player in position "position" in the current round.
        require
                all_players_valid_length : all_players.count = 4
                all_players_no_void : all_players /= VOID
                position_valid: position <= 4 AND position >= 1
        local
                index: INTEGER
                found: BOOLEAN
                id_player: INTEGER
        do
                from
                        index := all_players.lower
                until
                        index > all_players.upper OR found
                loop
                        if (all_players[index].get_player_posistion = position) then
                                found := TRUE
                                id_player := all_players[index].get_player_id
                        end
                        index := index+1
                end
                result := id_player
        ensure
                position_valid: result>0 and result<5
        end


        position_in_the_round(id_player:INTEGER; all_players: ARRAY[TR_PLAYER]):INTEGER
        --returns the current position in the round for player with id_player.
        require
                all_players_valid_length : all_players.count = 4
                all_players_no_void : all_players /= VOID
                id_player_valid: id_player <= 4 AND id_player >= 1
        local
                index: INTEGER
                found: BOOLEAN
                position: INTEGER
        do
                from
                        index := all_players.lower
                until
                        index > all_players.upper OR found
                loop
                        if (all_players[index].get_player_id = id_player) then
                                found := TRUE
                                position:= all_players[index].get_player_posistion
                        end
                        index := index+1
                end
                result := position
        ensure
                position_valid: result>0 and result<5
        end

        mark_a_card(card:TR_CARD; card_player: ARRAY[TR_CARD];played_cards:ARRAY[BOOLEAN])
        local
                index:INTEGER
                value: INTEGER
                type:STRING
        do
                from
                        index:= card_player.lower
                until
                        index>card_player.upper
                loop
                        value := card_player[index].get_card_value
                        type := card_player[index].get_card_type
                        if played_cards[index] = false then
                                if value = card.get_card_value AND type.is_equal (card.get_card_type) then
                                        played_cards[index] := true
                                end
                        end
                        index:= index+1
                end
        end

        smaller_card_available(card_player: ARRAY[TR_CARD];played_cards:ARRAY[BOOLEAN]):TR_CARD
        --play the smallest card available
        require
                valid_lengths: card_player.count = played_cards.count and card_player.count = 3
                sorted : card_player[0].get_card_weight_truco <= card_player[1].get_card_weight_truco AND
                                 card_player[1].get_card_weight_truco <= card_player[2].get_card_weight_truco

        local
                index:INTEGER
                found: BOOLEAN
                card_gr: TR_CARD
        do
                from
                        index:= card_player.lower
                until
                        index>card_player.upper OR found
                loop
                        if played_cards[index] = false then
                                --played_cards[index] := true
                                found := TRUE
                                card_gr := card_player[index]
                        end
                        index:= index+1
                end
                result := card_gr
        ensure
                card_valid: result /= VOID
        end

        greater_card_available(card_player: ARRAY[TR_CARD];played_cards:ARRAY[BOOLEAN]):TR_CARD
        --play the greater card available
        require
                valid_lengths: card_player.count = played_cards.count and card_player.count = 3
                sorted : card_player[0].get_card_weight_truco <= card_player[1].get_card_weight_truco AND
                                 card_player[1].get_card_weight_truco <= card_player[2].get_card_weight_truco

        local
                index: INTEGER
                found: BOOLEAN
                card_gr: TR_CARD
        do
                from
                        index:= card_player.upper
                until
                        index<card_player.lower OR found
                loop
                        if played_cards[index] = false then
                                found := TRUE
                                card_gr := card_player[index]
                        end
                        index:= index-1
                end
                result := card_gr
        ensure
                card_valid: result /= VOID
        end

        optimal_card_to_play(card_player: ARRAY[TR_CARD];played_cards:ARRAY[BOOLEAN]; card_to_win: TR_CARD):TR_CARD
        require
                valid_lengths: card_player.count = played_cards.count and card_player.count = 3
                card_to_win_no_void: card_to_win /= VOID
                sorted : card_player[0].get_card_weight_truco <= card_player[1].get_card_weight_truco AND
                                 card_player[1].get_card_weight_truco <= card_player[2].get_card_weight_truco

        local
                index:INTEGER
                weight_truco_ctw:INTEGER
                found: BOOLEAN
                card_gr: TR_CARD
        do
                weight_truco_ctw := card_to_win.get_card_weight_truco
                from
                        index:= card_player.lower
                until
                        index>card_player.upper OR found
                loop
                        if played_cards[index] = false then
                                if (weight_truco_ctw < card_player[index].get_card_weight_truco) then
                                        found := TRUE
                                        card_gr := card_player[index]
                                end
                        end
                        index:= index+1
                end
                --if there is no card that earns him,play smallest card
                if not found then
                        card_gr := smaller_card_available(card_player,played_cards)
                end
                result := card_gr
        ensure
                card_valid: result /= VOID
        end

feature {NONE,TR_TEST_AI} -- Calculate Points (for the envido)

        calculate_points(cards: ARRAY[TR_CARD]):INTEGER
        --calculate the points for the envido of 3 cards given
        require
                cards_valid: cards /= void
        local
                points1,points2,points3: INTEGER
                points_hand: INTEGER
        do
                --calculate the points of all possible pairs
                points1 := calculate_point(cards[cards.lower],cards[cards.lower+1])
                points2 := calculate_point(cards[cards.lower+1],cards[cards.upper])
                points3 := calculate_point(cards[cards.lower],cards[cards.upper])
                --stay with the largest
                points_hand := points1
                if (points_hand < points2) then
                        points_hand := points2
                end
                if (points_hand < points3) then
                        points_hand := points3
                end
                Result := points_hand
        ensure
                point_valid_hand: Result >= 0 and Result <= 33
        end

        calculate_point(card1:TR_CARD;card2:TR_CARD):INTEGER
        --calculates points between any two cards
        require
                cards_valid: card1 /= void and card2 /= void
        local
                type_card1, type_card2: STRING
                weight_envido_card1, weight_envido_card2: INTEGER
        do
                type_card1 := card1.get_card_type
                type_card2 := card2.get_card_type
                weight_envido_card1 := card1.get_card_weight_envido
                weight_envido_card2 := card2.get_card_weight_envido
                if (type_card1.is_equal (type_card2)) then
                        Result := weight_envido_card1 + weight_envido_card2 + 20
                else
                        if weight_envido_card1 > weight_envido_card2 then
                                Result := weight_envido_card1
                        else
                                Result := weight_envido_card2
                        end
                end
        ensure
                point_valid: Result >= 0 and Result <= 33
        end

feature{NONE,TR_TEST_AI} -- sort cards

        insertion_sort_by_weight_truco(cards: ARRAY[TR_CARD])
        -- Algorithm based on Insertion sort used to sort an array of TR_CARD by weight_truco
        require
                array_valid: cards /= void
                at_least_one: cards.count > 1
        local
                i,j: INTEGER
                card_aux: TR_CARD
        do
                from
                        i := cards.lower+1
                until
                        i > cards.upper
                loop
                        card_aux := cards[i]
                        from
                                j := i-1
                        until
                                j < cards.lower or (cards[j].get_card_weight_truco < card_aux.get_card_weight_truco)
                        loop
                                cards[j+1]:= cards[j]
                                j := j-1
                        end
                        cards[j+1] := card_aux
                        i := i+1
                end
        end

feature {NONE,TR_TEST_AI} -- Attribut

    difficulty: STRING

        team: INTEGER
        -- id team AI

    id_player_a, id_player_b: INTEGER
    --id the AI players

    player_cards_a, player_cards_b: ARRAY[TR_CARD]
    --cards of the players in the current hand

    played_cards_a, played_cards_b: ARRAY[BOOLEAN]
    --cards played by each player (position coincides with player_cards)

    envido_points_a, envido_points_b: INTEGER
    --envido points

    Floor_to_envido: INTEGER = 25
    --floor to accept or send the 'envido'
    Floor_to_real_envido: INTEGER = 30
    --floor to accept or send the 'real envido'
    Floor_to_falta_envido: INTEGER = 31
    --floor to accept or send the 'falta envido'

--    --bets
--    Envido      : STRING = envido
--    Real_envido : STRING = BC.real_envido
--    Falta_envido: STRING = {TR_BET_CONSTANTS}.falta_envido

--    Truco       : STRING = {TR_BET_CONSTANTS}.truco
--    Retruco     : STRING = {TR_BET_CONSTANTS}.retruco
--    Vale_cuatro : STRING = {TR_BET_CONSTANTS}.vale_cuatro

    BC : TR_BET_CONSTANTS
end
