note
	description: "Request from the client to the server, can be sent in a TR_PACKET"
	author: "Mabille Gabriel"
	date: "16/11/2013"
	revision: ""

class
	TR_CLIENT_REQUEST

inherit
	STORABLE

create
	make

feature
	make (a_request_type : STRING; a_obj : STORABLE)
	do
		request_type := a_request_type
		obj := a_obj
	end

feature -- attributs

	request_type : STRING

	obj : STORABLE
end
