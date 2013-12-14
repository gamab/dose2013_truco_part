note
	description: "Sent to the TR_SERVER when a client changes his team or his ready state"
	author: "Mabille Gabriel"
	date: "16/11/2013"
	revision: ""

class
	TR_CHANGING_PLAYER

inherit
	STORABLE

create
	make,
	make_for_ready_state_change,
	make_for_quit

feature

	make (a_name : STRING; a_new_team : INTEGER)
	require
		team_exist : a_new_team >= 1 AND a_new_team <=2
	do
		name := a_name
		new_team := a_new_team
	ensure
		team_exist : new_team >= 1 AND new_team <=2
	end

	make_for_ready_state_change (a_name : STRING; a_new_ready_state : BOOLEAN)
	do
		name := a_name
		new_ready_state := a_new_ready_state
	end

	make_for_quit (a_name : STRING)
	do
		name := a_name
	end

feature -- attributes

	name : STRING
		-- name of the player

	new_team : INTEGER
		-- new team of the player

	new_ready_state : BOOLEAN
		-- new ready state of the player
end
