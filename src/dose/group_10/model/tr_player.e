note
        description: " {TR_PLAYER} represent the player method for truco ."
        author: "tariqsenosy"
        date: "$Date$"
        revision: "$Revision$"

class
        TR_PLAYER
inherit
	STORABLE
        

create
        make

feature {NONE,TR_TEST_PLAYER}

        player_cards             :ARRAY[TR_CARD]
        player_played_cards      :ARRAY[TR_CARD]
        player_current_card      :TR_CARD
        player_name              :STRING
        player_id                :INTEGER
        player_team_id           :INTEGER
        player_position          :INTEGER
        the_player_team_score    :INTEGER
        played_card_counter      :INTEGER
        player_score             :INTEGER
        player_team_score        :INTEGER
        player_cards_calculation :INTEGER
        is_current_card          :BOOLEAN

feature {NONE}--represent the class headers

--make (a_player_id, a_team_id: INTEGER)
--set_player_name(the_player_name:STRING)
----get_player_name():STRING
--set_player_team_score(a_team_score:INTEGER)
----get_player_team_score():INTEGER
--set_player_id(a_id:INTEGER)
----get_player_id():INTEGER
--set_player_team_id(id:INTEGER)
----get_player_team_id():INTEGER
--set_cards (the_player_cards : ARRAY[TR_CARD])
----get_player_cards(): ARRAY[TR_CARD]
--set_player_posistion(a_position:INTEGER)
----get_player_posistion():INTEGER
----reset_played_cards()
--set_player_current_card(card:TR_CARD)
----get_cards_played():ARRAY[TR_CARD]
--get_player_current_card():TR_CARD
----is_player_has_current_card():BOOLEAN
--calculate_cards_weight() : INTEGER
----get_player_score():INTEGER


feature{ANY,TR_TEST_PLAYER}
        make (a_player_id, a_team_id: INTEGER)
               do
               create player_current_card.make ("",0)
               create player_cards.make_filled (player_current_card,0,2)
               create player_played_cards.make_filled (player_current_card,0,2)
                player_id := a_player_id
                 player_team_id := a_team_id
                played_card_counter:=0
                the_player_team_score:=0
                player_name:=""
				player_score:=0
				is_current_card:=false
                end


		set_player_name(the_player_name:STRING)
                    do
                    	player_name:=the_player_name
                    end


            get_player_name():STRING
                    do
                    	result:=player_name
                    end


		set_player_team_score(a_team_score:INTEGER)
		do
	 		the_player_team_score:=a_team_score

		end

   get_player_team_score():INTEGER
        do

		result:= the_player_team_score
		end


  		set_player_id(a_id:INTEGER)
                do
                player_id:=a_id
                player_position:=a_id
                end


           get_player_id():INTEGER
                do
                        result:=player_id

                end


          set_player_team_id(id:INTEGER)
                do
				player_team_id:=id

                end


        get_player_team_id():INTEGER
                do
              		result:=player_team_id
                end



           set_cards (the_player_cards : ARRAY[TR_CARD])
                local
                    do
                    	player_cards:=the_player_cards

                    end
          get_player_cards(): ARRAY[TR_CARD]
                do

                result:=player_cards
                end

		set_player_posistion(a_position:INTEGER)
                    do
				player_position:=a_position
                    end


            get_player_posistion():INTEGER
                    do
                  result:=player_position
                    end

		reset_played_cards()
			do
				played_card_counter:=0
				player_current_card.make ("",0)
				player_played_cards.make_filled (player_current_card,0,2)
				is_current_card:=false
			end


           set_player_current_card(card:TR_CARD)
                do
                is_current_card:=true
                create player_current_card.make (card.get_card_type, card.get_card_value)
                player_played_cards.put (player_current_card,played_card_counter)
                played_card_counter:=played_card_counter+1
                end


			get_cards_played():ARRAY[TR_CARD]
			do
				result:=player_played_cards
			end



           get_player_current_card():TR_CARD
                do
                result:=player_current_card

                end

          is_player_has_current_card():BOOLEAN
                do
              result:=is_current_card
                end

 calculate_cards_weight() : INTEGER
              local
              biggest : INTEGER
              secon : INTEGER
              do
              	if player_cards[0].get_card_weight_envido >= player_cards[1].get_card_weight_envido
              	and  player_cards[0].get_card_weight_envido >= player_cards[2].get_card_weight_envido
              	 then
              	biggest := player_cards[0].get_card_weight_envido
              	if player_cards[1].get_card_weight_envido >= player_cards[2].get_card_weight_envido
                then
              	secon := player_cards[1].get_card_weight_envido
              	else
              	secon := player_cards[2].get_card_weight_envido
              	end

              	else if player_cards[1].get_card_value >= player_cards[0].get_card_value
              	and  player_cards[1].get_card_value >= player_cards[2].get_card_value
              	then
              	biggest := player_cards[1].get_card_value
              	if player_cards[0].get_card_weight_envido >= player_cards[2].get_card_weight_envido
              	then
              	secon := player_cards[0].get_card_weight_envido
              	else
              	secon := player_cards[2].get_card_weight_envido
              	end

				else
				biggest := player_cards[2].get_card_value
				if player_cards[1].get_card_weight_envido >= player_cards[0].get_card_weight_envido
              	then
              	secon := player_cards[1].get_card_weight_envido
              	else
              	secon := player_cards[0].get_card_weight_envido
              	end
				end

			end

              	--if three are similar
				if player_cards[0].get_card_type = player_cards[1].get_card_type
				and player_cards[1].get_card_type = player_cards[2].get_card_type
				then
				player_score := 20+ biggest +secon
				-- first 2 r the same
				else if player_cards[0].get_card_type = player_cards[1].get_card_type
				then
				player_score := 20 +player_cards[0].get_card_weight_envido + player_cards[1].get_card_weight_envido

							-- second and third r equal
				else if player_cards[1].get_card_type = player_cards[2].get_card_type
				then
				player_score := 20 +player_cards[1].get_card_weight_envido + player_cards[2].get_card_weight_envido

									--first and last
				else if player_cards[0].get_card_type = player_cards[2].get_card_type
				then
				player_score := 20 +player_cards[0].get_card_weight_envido + player_cards[2].get_card_weight_envido

											-- no equal
				else
				player_score := biggest
				end
				end
				end
				end

				result := player_score
				end



         get_player_score():INTEGER
                do
                result:=calculate_cards_weight
                end
------------------------------------------------------------------------------------------------------------------------------------
         played_card(card:TR_CARD)
                do
                end
         update_score (counts_of_cards : INTEGER )
					do

                  end

end

