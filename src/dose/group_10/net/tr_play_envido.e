note
	description: "Summary description for {TR_PLAY_TRUCO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_PLAY_ENVIDO

inherit
	TR_ACTION

create
	make

feature {NONE}

	-- envido_type determines the kind of envido:
	-- 0: envido
	-- 1: real envido
	-- 2: falta envido
	envido_type: INTEGER

feature {ANY}

	make(a_player: TR_PLAYER; an_envido_type: INTEGER)
	require
		player_not_void: a_player /= Void
		envido_type_valid: an_envido_type >= 0 and an_envido_type <= 2
		-- and player is valid
	do
		player := a_player
		envido_type := an_envido_type
	end

	get_envido_type: INTEGER
	do
		Result := envido_type
	ensure
		Result >= 0
		Result <= 2
		Result = envido_type
	end

invariant
	envido_type >= 0 and envido_type <= 2

end
