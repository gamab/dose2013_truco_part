note
	description: "Centralized access to string constants used in network communication."
	author: "Janus Varmarken"
	date: "$Date$"
	revision: "$Revision$"

class
	TR_NETWORK_CONSTANTS
create
	make

feature
	make
		do
			create response_codes
		end
feature
	srv_unknown_player_name: STRING
		do
			result := "SERVEUR_UNKNOWN"
		end

feature -- public fields		
	response_codes: TR_NET_RESPONSE_CODES

end
