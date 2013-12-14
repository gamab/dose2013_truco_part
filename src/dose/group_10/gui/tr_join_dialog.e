note
	description: "Summary description for {TR_JOIN_DIALOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_JOIN_DIALOG

inherit
	EV_DIALOG
	EV_LAYOUT_CONSTANTS
		undefine
			default_create,
			copy
		end
	EV_KEY_CONSTANTS
		undefine
			default_create,
			copy
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
	make
		do
			initialize_window
			initialize_controls
		end

	name: STRING
		do
			Result := name_textbox.text
		end

	ip: STRING
		do
			Result := ip_textbox.text
		end

	port: INTEGER
		do
			Result := port_textbox.text.to_integer
		end

	is_cancelled: BOOLEAN
		do
			Result := cancelled
		end

feature {NONE}

	initialize_window
		do
			make_with_title ("Join game")
			set_minimum_size (join_dialog_width, join_dialog_height)
			disable_user_resize
			show_actions.extend (agent shown)
			close_request_actions.extend (agent cancel)
		end

	initialize_controls
		local
			label: EV_LABEL
			container: EV_VERTICAL_BOX
			button_container: EV_HORIZONTAL_BOX
			l_hsa: EV_HORIZONTAL_SPLIT_AREA
			l_lbl_width: INTEGER
		do
			l_lbl_width := (join_dialog_width / 3).rounded

			create container
			create button_container

			create name_textbox
			name_textbox.set_capacity (20)
			container.extend (produce_labelled_input ("Your name:", l_lbl_width, join_dialog_width, name_textbox))

			create ip_textbox
			ip_textbox.set_capacity (15)
			container.extend (produce_labelled_input("Host IP:", l_lbl_width, join_dialog_width, ip_textbox))

			create port_textbox
			port_textbox.set_capacity (5)
			container.extend (produce_labelled_input("Host port:", l_lbl_width, join_dialog_width, port_textbox))

			create cancel_button.make_with_text ("Cancel")
			cancel_button.select_actions.extend (agent cancel)
			set_default_size_for_button (cancel_button)
			button_container.extend(cancel_button)

			create ok_button.make_with_text ("Join")
			ok_button.select_actions.extend (agent ok)
			set_default_size_for_button (ok_button)
			button_container.extend(ok_button)

			container.extend (button_container)
			container.disable_item_expand (button_container)
			extend(container)
			set_minimum_size (container.width, container.height)

			set_default_cancel_button (cancel_button)
			set_default_push_button (ok_button)
		end

	produce_labelled_input(lbl_text: STRING; lbl_width: INTEGER; full_width: INTEGER; txt_box: EV_TEXT_FIELD) : EV_HORIZONTAL_BOX
		-- utility feature for producing labelled input boxes
		require
			valid_widths: lbl_width < full_width
			lbl_text_not_empty: lbl_text /= void and then lbl_text.count > 0
			txt_box_not_void: txt_box /= void
		local
			l_hb: EV_HORIZONTAL_BOX
			l_txt_box_width: INTEGER
			l_lbl: EV_LABEL
		do
			create l_lbl.make_with_text (lbl_text)
			l_lbl.set_minimum_width (lbl_width)
			l_lbl.align_text_left

			txt_box.set_minimum_width (full_width - lbl_width)

			create l_hb
			l_hb.extend (l_lbl)
			l_hb.extend (txt_box)
			result := l_hb
		ensure
			result_not_void: result /= void
		end

	shown
		do
			name_textbox.set_focus
		end

	cancel
		do
			cancelled := true
			hide
		end

	ok
		local
			msgbox: EV_WARNING_DIALOG
			l_dot: STRING
			l_ip_list: LIST[STRING]
			l_i: INTEGER
			l_ip_valid: BOOLEAN
		do
			l_dot := "."
			l_ip_list := ip.split (l_dot.character_32_item (1))
			l_ip_valid := l_ip_list.count = 4

			if l_ip_valid then
				from
					l_i := 1
				until
					l_i = l_ip_list.count + 1
				loop
					if not l_ip_list.at (l_i).is_natural_8 then
						l_ip_valid := false
					end
					l_i := l_i + 1
				end
			end

			if name_textbox.text.count > 0 and
					ip_textbox.text.count > 0 and
					port_textbox.text.is_integer_32 and
					l_ip_valid then
				cancelled := false
				hide
			else
				create msgbox.make_with_text ("You must enter a name, an IP address and a port number.")
				msgbox.show_modal_to_window (Current)
			end
		end

feature {NONE} -- Access

	name_textbox: EV_TEXT_FIELD
	ip_textbox: EV_TEXT_FIELD
	port_textbox: EV_TEXT_FIELD
	ok_button: EV_BUTTON
	cancel_button: EV_BUTTON
	cancelled: BOOLEAN

end
