note
	description: "A packet that truco server can understand."
	author: "Gabriel Mabille"
	date: "03/11/2013"
	revision: ""

class
	TR_PACKET
inherit
	STORABLE

create
	make

feature -- creator

	make(receivers_names : LINKED_LIST[STRING]; object_to_send : STORABLE)
	do
		receivers := receivers_names
		data := object_to_send
	end

feature -- add receiver

	add_receiver(receiver_name : STRING)
		-- add a receiver's name to the list of receivers
 	do

	end

feature -- attributs

	receivers : LINKED_LIST[STRING]
		-- list of receivers identified by their names

	data : STORABLE
		-- object to send

end
