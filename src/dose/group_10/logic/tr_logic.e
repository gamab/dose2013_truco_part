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
			players_turn		:TR_PLAYER--never mind
		pos						:INTEGER -- counter for cards
		round_number			:INTEGER-- the round number 1  2  3
		team1_score				:INTEGER-- score of the team1
		team2_score				:INTEGER--score of the team2
		betting_team			:INTEGER-- The team hwo send last bet
		current_game_points		:INTEGER-- raise of the game , first it 1 but when you press envido and accept it will be 2 and so on
		current_bet				:STRING-- if there a bet  what's this bet
		game_state				:STRING--never mind
		action					:BOOLEAN--never mind
		who_bet_id				:INTEGER
		game_state_obj			:TR_GAME_STATE
		the_end_of_the_hand		:BOOLEAN
		final_winner			:INTEGER
			current_player_id	:INTEGER
			current_dealer_id	:INTEGER

feature {ANY,TR_TEST_LOGIC}

	make
	--constractor that sets the players data to null , sets all cards randomly and sets Game_Points to 0
	local
		p:TR_PLAYER-- used to initialize the all_players array
		d:TR_CARD
	do
		create game_state_obj.make
		create  p.make(0,0)-- create the player with id=0, teamid = 0
		create d.make ("",0)--  ceate card
		create all_players.make_filled (p,0,3)-- make all_players array with size 4 and initialize
		game_state_obj.set_all_players (all_players)
		create rounds.make_filled (-1, 0,2)-- array to save who win	

		create deck_cards.make_filled (d,0,3)-- cards on deck
		game_state_obj.update_deck_cards (deck_cards)
		create cards.make_filled (d,0,39)-- all cards in the game
		create players_turn.make (0, 0)
		game_state_obj.set_players_turn (players_turn)
		current_player_id:=1
		game_state_obj.set_the_player_turn_id (current_player_id)
		current_game_points:=0
		game_state_obj.set_current_game_points (current_game_points)
		round_number:=1
		game_state_obj.set_round_number (round_number)
		current_bet:=""
		game_state_obj.set_current_bet (current_bet)
		game_state:=""
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
	Dealer()
	local
		array_of_cards:ARRAY[TR_CARD]
		new_cards:ARRAY[TR_CARD]
		a_card:TR_CARD
		i:INTEGER_32
		j:INTEGER
	do
		all_players := game_state_obj.get_all_players
		j:=0
		create a_card.make ("",i)
		create new_cards.make_filled (a_card,0 , 39)
		create array_of_cards.make_filled (a_card, 0,2)--initilization
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
			all_players[j].set_cards (array_of_cards)
			j:=j+1
		end
		game_state_obj.set_all_players (all_players)
		game_state_obj.set_the_player_turn_id (1)
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
                      do
                                game_state_obj.set_current_bet ("envido")
                                game_state_obj.set_action
                               current_bet:="envido"
                               action:=true
                               who_bet_id:=a_betting_player_id
                               game_state_obj.set_who_bet_id (who_bet_id)

                                                        if
                                                                a_betting_player_id=1 or a_betting_player_id=3
                                                        then
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
	do

		game_state_obj.set_current_bet ("realenvido")
		game_state_obj.set_action
		current_bet:="realenvido"
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
	do
		game_state_obj.set_current_bet ("faltaenvido")
		game_state_obj.set_action
		current_bet:="faltaenvido"
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
	do
		game_state_obj.set_current_bet ("truco")
		game_state_obj.set_action
		current_bet:="truco"
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
                     do
                               game_state_obj.set_current_bet ("retruco")
                               game_state_obj.set_action
                               current_bet:="retruco"
                               action:=true
                               who_bet_id:=a_betting_player_id
                               game_state_obj.set_who_bet_id (who_bet_id)


                                                        if
                                                                a_betting_player_id=1 or a_betting_player_id=3
                                                        then
                                                                 betting_team:=1
                                                        else
                                                                 betting_team:=2
                                                        end

                          -- betting_team:=( a_betting_player_id\\4)+1
                           game_state_obj.set_betting_team (betting_team)

   end
---------------------------------------------------------------------------------------------------------------------

	is_vale_cuatro_allowed(local_player: TR_PLAYER):BOOLEAN
	do
		result:=game_state_obj.is_vale_cuatro_allowed (local_player)
	end

--------------------------------------------------------------------------------------------------------------------

   send_valle_cuatro(a_betting_player_id:INTEGER)
                do
                                game_state_obj.set_current_bet ("vallecuatro")
                                game_state_obj.set_action
                                current_bet:="vallecuatro"
                                action:=true
                                who_bet_id:=a_betting_player_id
                                game_state_obj.set_who_bet_id (who_bet_id)


                                                        if
                                                                a_betting_player_id=1 or a_betting_player_id=3
                                                        then
                                                                 betting_team:=1
                                                        else
                                                                 betting_team:=2
                                                        end


                          -- betting_team:=( a_betting_player_id\\4)+1
                           game_state_obj.set_betting_team (betting_team)

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

	get_current_bet():STRING
	do
		result:=game_state_obj.current_bet
	end

---------------------------------------------------------------------------------------------------------------------

	is_end_of_game():BOOLEAN
	do
		result:=  (game_state_obj.team1_score>=24 or game_state_obj.team2_score >= 24)
	end
----------------------------------------not implemented yet --------------------------------------------------------------------

  win_round(winner:TR_PLAYER)
                do
                	if round_number > 0 then


                      rounds.put (winner.get_player_team_id,round_number-1)
                      game_state_obj.set_round (winner.get_player_team_id,round_number-1)
                      if
                              round_number<3
                       then
                      round_number:=round_number+1
                      game_state_obj.set_round_number (round_number)
                      set_players_positions(winner.get_player_id)-- will reorder players
                      else
                      the_end_of_the_hand:=true
                              round_number:=1
                              game_state_obj.set_round_number (1)
                              set_players_positions(1)
                      end

                       game_state_obj.set_winner_round (winner)
		end
   end
-------------------------------------------------------------------------------------------


   set_current_game_state(the_game_state:TR_GAME_STATE)
              do
                   game_state_obj:=the_game_state
                   rounds:=game_state_obj.get_round
                   current_player_id:=game_state_obj.get_the_player_turn_id
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
                                deck_cards.put (card,(local_player.get_player_posistion-1))
                                game_state_obj.update_deck_cards (deck_cards)
                    from
                              i:=0
                     until
                              i>2
                     loop
                            if
                                    player_current_cards[i].get_card_type.is_equal (card.get_card_type)
                                    and player_current_cards[i].get_card_value=card.get_card_value
                            then
                                    player_current_cards[i].set_to_void()
                                    local_player.set_cards (player_current_cards)
                                    i:=2
                          end
                                                    i:=i+1
                      end




                    from i:=0 until i=4 loop
                      	if all_players.at (i).get_player_name.is_equal (local_player.get_player_name) then
                      		all_players.at (i) := local_player
                      		i:=3
                      	end
                      	i:=i+1
                      end

                     new_player_turn := game_state_obj.get_the_player_turn_id\\4 + 1
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
                                the_end_of_the_hand:=false
                             game_state_obj.set_end_hand
                             if
                                     current_dealer_id<4
                             then
                                     current_dealer_id:=current_dealer_id+1
                                     else
                                             current_dealer_id:=1
                             end
                             set_players_positions (current_dealer_id)

                               create rounds.make_filled (-1,0,2)
                               action:=false
                               game_state_obj.remove_action
                               current_bet:=""
                               game_state_obj.set_current_bet (current_bet)
                               deck_cards.make_empty
                               game_state_obj.update_deck_cards (deck_cards)
                               round_number:=1
                               game_state_obj.set_round_number (round_number)
--
   end

---------------------------------------------------------------------

  set_players_positions(winner_id:INTEGER)

                local
                        j:INTEGER
                        i:INTEGER
      do
                          i:=winner_id-1
                          from j:=0 until j>3
                          loop
                                  if  i>3 then i:=0
                                  end
                                  all_players[i].set_player_posistion (j+1);
                                  j:=j+1;i:=i+1
                          end
      end
-------------------------------------------------------

        send_accept(team:INTEGER)
		local
			add_score :INTEGER
		do
			if current_bet.is_equal ( "truco") then
				current_game_points := current_game_points+1
				game_state_obj.set_current_game_points (current_game_points)
			end
			if current_bet.is_equal ("retruco") then
				current_game_points := current_game_points+2
				game_state_obj.set_current_game_points (current_game_points)
			end
			if current_bet.is_equal ("vallecuatro") then
				current_game_points := current_game_points+3
				game_state_obj.set_current_game_points (current_game_points)
			end
			if
				current_bet.is_equal ("envido") or
				current_bet.is_equal ("realenvido") or
				current_bet.is_equal ("faltaenvido")
			then
				if current_bet.is_equal ("envido")  then
					add_score := 2
				else if current_bet.is_equal ("realenvido")  then
					add_score := 3
				else if current_bet.is_equal ("faltaenvido")  then
					add_score := 4
				end
			end
		end


                                 -- if first team wins
                if
                all_players[0].calculate_cards_weight > all_players[1].calculate_cards_weight
                        and all_players[0].calculate_cards_weight > all_players[3].calculate_cards_weight
                        or all_players[2].calculate_cards_weight > all_players[1].calculate_cards_weight
                        and all_players[2].calculate_cards_weight > all_players[3].calculate_cards_weight
                then
                team1_score := team1_score + add_score
                all_players[0].set_player_team_score (team1_score)
                all_players[2].set_player_team_score (team1_score)
                game_state_obj.set_team1_score (team1_score)
                                 -- if second wins
                else if
                all_players[0].calculate_cards_weight > all_players[1].calculate_cards_weight
                        and all_players[0].calculate_cards_weight > all_players[3].calculate_cards_weight
                        or all_players[2].calculate_cards_weight > all_players[1].calculate_cards_weight
                        and all_players[2].calculate_cards_weight > all_players[3].calculate_cards_weight
                then
                team2_score := team2_score + add_score
                all_players[1].set_player_team_score (team2_score)
                all_players[3].set_player_team_score (team2_score)
                game_state_obj.set_team2_score (team2_score)

                -- if first the same as second
                else if all_players[0].calculate_cards_weight = all_players[1].calculate_cards_weight
                then
                if
                all_players[0].get_player_posistion < all_players[1].get_player_posistion
                then
                team1_score := team1_score + add_score
                all_players[0].set_player_team_score (team1_score)
                all_players[2].set_player_team_score (team1_score)
                                game_state_obj.set_team1_score (team1_score)
                else
                team2_score := team2_score + add_score
                all_players[1].set_player_team_score (team2_score)
                all_players[3].set_player_team_score (team2_score)
                                game_state_obj.set_team2_score (team2_score)

                end
                                  -- if first  the same as forth
                else if all_players[0].calculate_cards_weight = all_players[3].calculate_cards_weight
                then
                if
                all_players[0].get_player_posistion < all_players[3].get_player_posistion
                then
                team1_score := team1_score + add_score
                all_players[0].set_player_team_score (team1_score)
                all_players[2].set_player_team_score (team1_score)
                game_state_obj.set_team1_score (team1_score)

                else
                team2_score := team2_score + add_score
                all_players[1].set_player_team_score (team2_score)
                all_players[3].set_player_team_score (team2_score)
                game_state_obj.set_team2_score (team2_score)

                end

                                  -- if third  the same as second
                else if all_players[2].calculate_cards_weight = all_players[1].calculate_cards_weight
                then
                if
                all_players[2].get_player_posistion < all_players[1].get_player_posistion
                then
                team1_score := team1_score + add_score
                all_players[0].set_player_team_score (team1_score)
                all_players[2].set_player_team_score (team1_score)
                game_state_obj.set_team1_score (team1_score)

                else
                team2_score := team2_score + add_score
                all_players[1].set_player_team_score (team2_score)
                all_players[3].set_player_team_score (team2_score)
                game_state_obj.set_team2_score (team2_score)

                end
                -- if third  the same as forth
                else if all_players[2].calculate_cards_weight = all_players[3].calculate_cards_weight
                then
                if
                all_players[2].get_player_posistion < all_players[3].get_player_posistion
                then
                team1_score := team1_score + add_score
                all_players[0].set_player_team_score (team1_score)
                all_players[2].set_player_team_score (team1_score)
                game_state_obj.set_team1_score (team1_score)

                else
                team2_score := team2_score + add_score
                all_players[1].set_player_team_score (team2_score)
                all_players[3].set_player_team_score (team2_score)
                game_state_obj.set_team2_score (team2_score)


                                          end

                                            end
                                                end
                                                end
                                                end
                                                end
                                                end
                                 -- end_hand ()
                                end

                         current_bet:=""
                         game_state_obj.set_current_bet (current_bet)
                        action:=false
                        game_state_obj.remove_action
                        betting_team:=team
                        game_state_obj.set_betting_team (team)


                end

-------------------------------------------

        send_reject(team:INTEGER)
                do
                        if team = 1
                        then
                                team2_score := current_game_points
                                all_players[1].set_player_team_score (team2_score)
                                all_players[3].set_player_team_score (team2_score)
                                game_state_obj.set_team2_score (team2_score)

                        else
                                team1_score :=current_game_points
                                all_players[0].set_player_team_score (team1_score)
                                all_players[2].set_player_team_score (team1_score)
                                game_state_obj.set_team1_score (team1_score)

                        end
                        current_bet:=""
                        game_state_obj.set_current_bet (current_bet)
                        action:=false
                        game_state_obj.remove_action
                        betting_team:=team
                        game_state_obj.set_betting_team (team)
                end


end_game()
  do
        if team1_score >=24 then
                final_winner :=1
        else final_winner:= 2 end
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


end_round()
local
c:TR_CARD
do
        create c.make ("",0)
        c.set_to_void
        all_players[0].set_player_current_card (c)
        all_players[1].set_player_current_card (c)
        all_players[2].set_player_current_card (c)
        all_players[3].set_player_current_card (c)

        if
                all_players[1].get_player_posistion=deck_card_winner(deck_cards)
                or all_players[3].get_player_posistion=deck_card_winner(deck_cards)
        then
                rounds.put (2,round_number-1)
                game_state_obj.set_round (2,round_number-1)
        else
        rounds.put (1,round_number-1)
        game_state_obj.set_round (1,round_number-1)

        end
        round_number:=round_number+1
        game_state_obj.set_round_number (round_number)
        if round_number=4 then end_hand
        end
  end
------------------------------------------------------------------------------------


deck_card_winner(the_card_in_array:ARRAY[TR_CARD]):INTEGER
                local
                        max:INTEGER
                        i:INTEGER
                        index:INTEGER
                do
                max:= -1
                        from i:=0
                        until i>3
                        loop
                                if the_card_in_array[i].get_card_weight_truco>max
                                then
                                        max := the_card_in_array[i].get_card_weight_truco
                                        index:=i
                                end
                                i:=i+1
                        end
                        result := index
                end

------------------------------------------------------------------------------------

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


          set_game_state(current_state:STRING)
                do
                --game_state:=current_state
                end

          current_game_state():STRING
                do
                result:=game_state
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
