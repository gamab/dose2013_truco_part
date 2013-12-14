note
	description: "TR_SERVER_PLAYER_ARRAY represent an array of TR_SERVER_PLAYER storable so that it can go through the net"
	author: "Gabriel Mabille"
	date: "2/12/2013"
	revision: ""

class
	TR_SERVER_PLAYER_ARRAY

inherit
	ARRAY[TR_SERVER_PLAYER]

	STORABLE
	undefine
		is_equal, copy
	end

create
	make,
	make_filled,
	make_empty
end
