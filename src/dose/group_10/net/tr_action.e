note
	description: "Summary description for {TR_ACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TR_ACTION

inherit
	STORABLE

feature {TR_PLAY_CARD, TR_PLAY_TRUCO, TR_PLAY_ENVIDO}

	player: TR_PLAYER


feature {ANY}

	get_player: TR_PLAYER
	do
		Result := player
	ensure
		Result /= Void
		Result = player
	end

end
