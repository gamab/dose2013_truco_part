note
	description: "Sent to the TR_SERVER when a client wants to join the game"
	author: "Mabille Gabriel"
	date: "16/11/2013"
	revision: "$Revision$"

class
	TR_JOINING_PLAYER

inherit
	STORABLE

create
	make,
	make_ai
feature

	make (a_name : STRING; a_client_port : INTEGER; a_team : INTEGER)
		--Makes a TR_JOINING_PLAYER assuming it is not an AI
	require
		port_possible : a_client_port > 0
		team_exist : a_team >= 1 AND a_team <=2
	do
		name := a_name
		client_port := a_client_port
		team := a_team
		is_ai := false
	ensure
		port_possible : client_port > 0
		team_exist : team >= 1 AND team <=2
	end

	make_ai (a_name : STRING; a_client_port : INTEGER; a_team : INTEGER a_is_ai : BOOLEAN)
		--Makes a TR_JOINING_PLAYER and remember if it is an AI or not
	require
		port_possible : a_client_port > 0
		team_exist : a_team >= 1 AND a_team <=2
	do
		name := a_name
		client_port := a_client_port
		team := a_team
		is_ai := a_is_ai
	ensure
		port_possible : client_port > 0
		team_exist : team >= 1 AND team <=2
	end

feature -- attributes

	name : STRING

	client_port : INTEGER

	team : INTEGER

	is_ai : BOOLEAN
end
