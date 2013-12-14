note
	description: "Object representing all information usefull for the server to know about a player"
	author: "Gabriel Mabille"
	date: "28/10/13"
	revision: ""

class
	TR_SERVER_PLAYER

create
	make_complete

feature {ANY} -- creators

	make_complete(player_name : STRING; player_team : INTEGER; player_ip : INET_ADDRESS; player_port : INTEGER; player_ai : BOOLEAN)
		-- make a TR_SERVER_PLAYER
	require
		team_is_possible : player_team >= 1 AND player_team <= 2
		port_exist : player_port>0
	do
		name := player_name
		team := player_team
		ip := player_ip
		port := player_port
		is_ai := player_ai
		if is_ai then
			is_ready := true
		else
			is_ready := false
		end
	end

feature {ANY} -- setter

	set_team(new_team : INTEGER)
		-- change the team of a player by new_team
	require
		team_is_possible : new_team >= 1 AND new_team <= 2
	do
		team := new_team;
	end

	set_port(new_port : INTEGER)
		-- change the team of a player by new_team
	require
		port_exist : new_port>0
	do
		port := new_port
	end

	change_ready_state(player_ready : BOOLEAN)
	do
		is_ready := player_ready
	end

feature {ANY} -- attributes

	name : STRING
		-- contains the name of the player must be unique

	team : INTEGER
		-- contains the team of a player

	ip : INET_ADDRESS
		-- contains the IP of the client

	port : INTEGER
		-- contains the port at which the client is listening

	is_ai : BOOLEAN
		-- returns whether a player is an ai player or not

	is_ready : BOOLEAN
		-- returns whether a player is ready to start a game or not

end
