note
	description: "Summary description for {TR_PLAY_CARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_PLAY_CARD

inherit
	TR_ACTION

create
	make

feature {NONE}

	card: TR_CARD

feature {ANY}

	make(a_player: TR_PLAYER; a_card: TR_CARD)
	require
		player_not_void: a_player /= Void
		card_not_void: a_card /= Void
		-- and they are both valid
	do
		player := a_player
		card := a_card
	end

	get_card: TR_CARD
	do
		Result := card
	ensure
		Result /= Void
		Result = card
	end

end
