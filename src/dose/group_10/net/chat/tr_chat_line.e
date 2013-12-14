note
	description: "Object representing a Chat Line"
	author: "Gabriel Mabille"
	date: "28/10/13"
	revision: ""

class
	TR_CHAT_LINE

inherit
	STORABLE
	redefine
		out
	end

create
	make_filled

feature -- creator

	make_filled(a_player : TR_PLAYER; a_message : STRING)
		-- make a chat line send by a_player with the message a_message
	require
		player_not_void: a_player /= Void
		-- message_valid: a_message /= Void and then not a_message.is_empty
	do
		player := a_player
		message := a_message
	ensure
		message_set: message = a_message
		player_set: player = a_player
	end

feature -- out

	out() : STRING
	do
		-- result := name + " : " + message
		result := player.get_player_name + ": " + message
	ensure then
		result_not_empty: result /= Void and then not result.is_empty
	end

feature -- attributes

	player : TR_PLAYER
		-- Sender of this chat line

	message : STRING
		-- message writen
end
