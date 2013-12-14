note
	description: "Object representing a Chat"
	author: "Gabriel Mabille"
	date: "28/10/13"
	revision: ""

class
	TR_CHAT

inherit
	ANY
	redefine
		out
	end

create
	make

feature -- creator

	make
		-- make the chat
	do
		create messages.make
	end

feature -- add

	add_line(line : TR_CHAT_LINE)
	do
		-- add a line to the chat
		messages.extend (line.out)
	end

feature --out

	out : STRING

	local
		i : INTEGER
		res : STRING
		-- gives the chat as a string
	do
		res := ""
		from messages.start
		until messages.exhausted
		loop
			res := res + messages.item.out + "%N"
			messages.forth
		end

		result := res
	end

feature {NONE,TR_TEST_CHAT} -- attributes

	messages : LINKED_LIST[STRING]
end
