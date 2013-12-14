note
	description: "Listener interface used by classes that want to receive notifications of incoming chat messages"
	author: "Janus Varmarken"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TR_I_CHAT_LISTENER

feature
	chat_msg_received(msg: TR_CHAT_LINE)
		-- invoked by the observed object when a chat message is received.
		require
			line_not_void: msg /= Void
		deferred

		end
end
