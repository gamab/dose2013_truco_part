note
	description: "Answer to a request from the server to the client, can be sent in a TR_PACKET"
	author: "Mabille Gabriel"
	date: "16/11/2013"
	revision: ""

class
	TR_SERVER_ANSWER
inherit
	STORABLE

create
	make
feature --creator
	make(answer : STRING)
	do
		message := answer
	end
feature -- attributs

	message : STRING
end
