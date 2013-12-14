note
	description: "Summary description for {TR_PLAY_TRUCO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_PLAY_TRUCO

inherit
	TR_ACTION

create
	make

feature {NONE}

	truco_value: INTEGER

feature {ANY}

	make(a_player: TR_PLAYER; a_truco_value: INTEGER)
	require
		player_not_void: a_player /= Void
		truco_value_minimum: a_truco_value >= 2
		truco_value_maximum: a_truco_value <= 4
		-- and player is valid
	do
		player := a_player
		truco_value := a_truco_value
	end

	get_truco: INTEGER
	do
		Result := truco_value
	ensure
		Result >= 2
		Result <= 4
		Result = truco_value
	end
end
