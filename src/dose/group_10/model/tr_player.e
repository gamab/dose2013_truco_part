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

feature{ANY}
	cards_points			 :INTEGER

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
        cards_points := calculate_points(player_played_cards)
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
		create player_current_card.make ("",0)
		create player_played_cards.make_filled (player_current_card,0,2)
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

feature {NONE}

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
        points : INTEGER
    do
    	type_card1 := card1.get_card_type
        type_card2 := card2.get_card_type
        weight_envido_card1 := card1.get_card_weight_envido
        weight_envido_card2 := card2.get_card_weight_envido
        if (type_card1.is_equal (type_card2)) then
        	points := weight_envido_card1 + weight_envido_card2 + 20
        else
        	if weight_envido_card1 > weight_envido_card2 then
            	points := weight_envido_card1
            else
            	points := weight_envido_card2
            end
        end
        result := points
	ensure
    	point_valid: Result >= 0 and Result <= 33
	end

feature {ANY}

	get_player_score():INTEGER
    do
    	result:= cards_points
    end
------------------------------------------------------------------------------------------------------------------------------------


	played_card(card:TR_CARD)
    do

    end

	update_score (counts_of_cards : INTEGER )
	do

	end

end

