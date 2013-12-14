note
	description: "Class that builds the chat section of the game main window (the table window)"
	author: "Janus Varmarken"
	date: "$Date$"
	revision: "$Revision$"

class
	TR_CHAT_SECTION
inherit
	EV_VERTICAL_BOX

	EV_KEY_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	TR_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

create
	make

feature
	make(a_controller: TR_CONTROLLER)
		require
			controller_not_void: a_controller /= Void
		local
			l_txt_area_height: INTEGER
		do
			default_create

			set_minimum_size (chat_section_width, 300)
				-- set min size of container

			init_emotes
			init_txt_area(chat_section_width)
			init_enter_msg_section(chat_section_width)
			init_chat_log
			init_combo_box

			controller := a_controller
			controller.register_chat_received_action (agent chat_msg_received)
				-- register self as chat listener
		end

	chat_msg_received(chat_line: TR_CHAT_LINE)
		-- receive chat update from the network
		require else
			chat_line_not_void: chat_line /= Void
		do
			if chat_line.message.count > 0 then
				chat_log.extend (chat_line)
				update_chat (chat_line)
			end
		ensure then
			chat_log.has (chat_line)
		end

feature {NONE} -- initialization
	init_chat_log
		-- initializes the internal container that stores all chat messages
		require
			chat_log_void: chat_log = Void
		local
			l_list: ARRAYED_LIST[TR_CHAT_LINE]
		do
			create l_list.make (0)
			l_list.compare_references
			chat_log := l_list
		ensure
			chat_log_not_void: chat_log /= Void
		end

	init_txt_area(a_min_width: INTEGER)
		-- creates the text area where sent/received chat messages are displayed
		do
			create txt_area
			txt_area.disable_edit
			txt_area.disable_capture
			txt_area.set_minimum_width (a_min_width)
			--txt_area.set_minimum_height (a_min_height)
			txt_area.enable_word_wrapping
			extend(txt_area)
		end

	init_txt_box(a_min_width: INTEGER)
		do
			create txt_box
			txt_box.set_tooltip("Type to chat")
			txt_box.set_minimum_width(a_min_width)
			txt_box.key_release_actions.extend(agent enter_key_released)
		end


	init_btn_send(a_min_width: INTEGER)
		local
			l_font: EV_FONT
		do
			create btn_send.make_with_text ("Send")
			btn_send.set_minimum_width (a_min_width)
			create l_font
			l_font.set_height (8)
			btn_send.set_font (l_font)
			btn_send.select_actions.extend (agent send_pressed)
		end

	init_enter_msg_section(a_min_width: INTEGER)
		require
			btn_send = Void
			txt_box = Void
		local
			l_btn_width: INTEGER
			l_hb: EV_HORIZONTAL_BOX
		do
			l_btn_width := (a_min_width / 4).rounded
				-- use a fith of the available width for the send button

			init_txt_box(a_min_width - l_btn_width)
				-- setup text box for entering messages
			init_btn_send (l_btn_width)
				-- setup send button
			btn_send.set_minimum_height (txt_box.height)
			create l_hb
			l_hb.extend (txt_box)
			l_hb.extend (btn_send)
			extend(l_hb)
			disable_item_expand (l_hb)
		end

	init_combo_box
		require
			emotes_not_void: emotes /= Void
		do
			create emote_combo_box
			emote_combo_box.disable_edit
			emote_combo_box.select_actions.extend (agent combo_box_item_selected)

			fill_combo_box

			extend (emote_combo_box)
			disable_item_expand (emote_combo_box)
		end

	fill_combo_box
		local
			l_nice_str: STRING
		do
			-- default value
			emote_combo_box.extend (create {EV_LIST_ITEM}.make_with_text ("* Send private signal *"))

			from emotes.start until emotes.after loop
				l_nice_str := emotes.item_for_iteration
				emote_combo_box.extend (create {EV_LIST_ITEM}.make_with_text (l_nice_str))
				emotes.forth
			end
		end

	init_emotes
		-- create the allowed emotes
		do
			create emotes.make (10)
			emotes.extend ("Raise eyebrows", "{:)") -- raise eyebrows
			emotes.extend ("Close one eye", ";)") -- close one eye
			emotes.extend ("Move mouth to one side", ":i") -- move mouth to one side
			emotes.extend ("Bite the lower lip", ":B") -- bite the lower lip
			emotes.extend ("Make a kiss", ":*") -- make a kiss
			emotes.extend ("Open mouth", ":O") -- open mouth
			emotes.extend ("Close both eyes", "-_-") -- close both eyes
			emotes.extend ("Move head to one side", "  ^_^") -- move head to one side
		end

feature {NONE} -- event handling
	send_pressed
		local
			l_cl: TR_CHAT_LINE
				-- wraps the chat entered by the user
			l_private: BOOLEAN
				-- is the message private?
		do
			if txt_box.text.count > 0 then
				create l_cl.make_filled (controller.get_local_player, txt_box.text)
				txt_box.remove_text -- clear input box

				l_private := is_emote (l_cl.message)
				controller.gui_chat_message_sent (l_cl, l_private)

				-- testing
				-- controller.handle_network_chat_update (l_cl)
					-- check that line "bounces" back
			end
		end

	enter_key_released (a_key: EV_KEY)
		do
			if a_key.code = key_enter then
				send_pressed
			end
		end

	combo_box_item_selected
		local
			l_key: STRING
		do
			-- get key from value
			from emotes.start until emotes.after loop
				if emote_combo_box.selected_item.text.is_equal (emotes.item_for_iteration) then
					l_key := emotes.key_for_iteration
				end

				emotes.forth
			end

			if l_key /= Void then
				txt_box.set_text (l_key)
				send_pressed
				emote_combo_box.wipe_out
				fill_combo_box

				-- test receive
				--chat_msg_received (create {TR_CHAT_LINE}.make_filled (controller.get_local_player, l_key))
			end
		end

feature {NONE} -- features for updating the GUI elements in the chat section

	update_chat (a_line: TR_CHAT_LINE)
		-- updates the chat display with new data
		require
			a_line_not_void: a_line /= Void
			a_line_not_empty: a_line.message.count > 0
		do
			txt_area.append_text (pretty_print_line(a_line))
			txt_area.scroll_to_end
				-- scroll to end to ensure user sees the latest messages
		ensure

		end

	pretty_print(a_list : LIST[TR_CHAT_LINE]) : STRING
		-- a (to be enhanced) pretty print of a list of chat messages
		-- (as for this first implementation: this is exactly what TR_CHAT used to do)
		require
			a_list_not_void: a_list /= Void
		local
			l_result : STRING
		do
			l_result := ""
			from a_list.start
			until a_list.exhausted
		loop
			l_result := l_result + a_list.item.out + "%N"
			a_list.forth
		end
			result := l_result
		end

	pretty_print_line(a_line : TR_CHAT_LINE) : STRING
		-- a (to be enhanced) pretty print of a chat message
		require
			a_line_not_void: a_line /= Void
			a_line_not_empty: a_line.message.count > 0
		do
			if is_emote (a_line.message) then
				Result := a_line.player.get_player_name + ": " + emotes[a_line.message] + "%N"
			else
				Result := a_line.out + "%N"
			end
		end

	is_emote (a_string: STRING) : BOOLEAN
		-- is this string an emote?
		do
			Result := emotes.has (a_string)
		end

feature {NONE} -- fields
	controller: TR_CONTROLLER
		-- the centralized CONTROLLER
		-- used by this class to communicate with its surroundings
	txt_area: EV_TEXT
		-- text area where sent+received messages are displayed
	txt_box: EV_TEXT_FIELD
		-- text box where the user enters new chat messages
	btn_send: EV_BUTTON
		-- the "send message" button
	chat_log: LIST[TR_CHAT_LINE]
		-- holds the raw chat data
	emote_combo_box: EV_COMBO_BOX
		-- the combobox for emotes
	emotes: HASH_TABLE[STRING, STRING]
		-- the possible emotes

end
